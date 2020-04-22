import threading, os, subprocess, hashlib, time, shlex
from client.helper import Helper


class Fuzzer():
    prev_hsh = ''
    helper = None
    timer = None
    proc = None
    out_dir = ''

    def __init__(self, job, engine, target, options):
        self.job = job
        self.engine = engine
        self.target = target
        self.options = options
        self.helper = Helper()
        self.crashes = []

    def fail(self, err=None):
        print "Exiting job as failed:"
        if err is not None: 
            print err
        self.job = self.helper.move_job_state(self.job, '*', 'Failed')
        if err is not None:
            self.helper.update_job_output(self.job['id'], err)

        try:
            if self.proc is not None:
                self.proc.terminate()
        except:
            call_args = [
            'pkill',
            'afl-fuzz'
            ]
            subprocess.call(call_args)

        if self.timer is not None:
            self.timer.cancel()

    def watch_for_crash(self, dir):
        for root, dirs, samples in os.walk(dir):
            for sample in samples:
                try:
                    found = self.crashes.index(sample)
                except:
                    self.crashes.append(sample)
                    self.helper.report_crash_sample(self.job, self.target, dir + os.sep + sample)


    def start(self):
        def probe_afl():
            #print "probe_afl"
            out_dir = self.out_dir
            self.watch_for_crash(out_dir + os.sep + 'crashes')
            #raw_stats = self.output + "\n\n"
            #print raw_stats
            #raw_stats = None
            try:
                raw_stats = proc.stdout.read()
                raw_stats += open(out_dir + '/fuzzer_stats').read()
                print raw_stats
            except Exception as e:
                print "error opening raw_stats"
                self.fail(e.message)
        
            hsh = hashlib.md5(raw_stats)
            if hsh != self.prev_hsh:
                #print raw_stats
                #print self.output
                self.job = self.helper.move_job_state(self.job, 'Allocated', 'Active')
                self.helper.update_job_output(self.job['id'], raw_stats)
                self.prev_hsh = hsh

        def monitor_thread(proc):
            #probe_afl()
            e = threading.Event()
            while not e.wait(1): #We update the status of afl with server every 20 seconds
                probe_afl()

        
        print "Fuzzing with AFL++ engine"
        in_dir = os.getcwd() + os.sep + self.options['input_dir']
        #print "input directory: " + in_dir
        out_dir = os.getcwd() + os.sep + 'fuzzdata/sessions/' + os.path.basename(self.target['path']) + ".afl-fuzz." + str(time.time()) + ".session"
        self.out_dir = out_dir
        #print "output directory: " + out_dir
        tout = self.options['timeout']
        #print "timeout: " + tout
        #print os.getcwd() + os.sep + "engine" + os.sep + "afl/afl-fuzz"
        call_args = [
            #self.engine['path'],
            os.getcwd() + os.sep + "engine" + os.sep + "afl/afl-fuzz",
            '-i',
            in_dir,
            '-o',
            out_dir,
        ]

        fargs = self.options['fuzzer_args']
        if fargs is not None and len(fargs) > 0:            
            call_args.extend(shlex.split(fargs))

        if tout is not None and len(tout) > 0:
            call_args.append('-t')
            call_args.append(tout)

        call_args.append('--')
        call_args.append(self.target['path'])

        targs = self.options['target_args']
        if targs is not None and len(targs) > 0:            
            call_args.extend(shlex.split(targs))
        
        print "Fuzzing with command:"
        for x in call_args:
            print x,
        print

        proc = subprocess.Popen(call_args, 
                                stdout=subprocess.PIPE, 
                                stderr=subprocess.STDOUT)

        self.proc = proc

        t = threading.Thread(target=monitor_thread, args=(proc,))
        t.start()
        try:
            if proc.wait() != 0:
                output = proc.stdout.read()
                self.fail(output)
        finally:
            print "finally proc terminate"
            proc.terminate()
            try:
                proc.wait(timeout=0.2)
                print('== subprocess exited with rc =', proc.returncode)
            finally:
                print "subprocess timed out"
        
from app import app
from model.FuzzingPlatform import FuzzingPlatform
from model.FuzzingArch import FuzzingArch
from model.FuzzingEngine import FuzzingEngine
from model.FuzzingJobState import FuzzingJobState
from model.FuzzingTarget import FuzzingTarget
from model.FuzzingScript import FuzzingScript
from model.FuzzingOptionType import FuzzingOptionType
from model.FuzzingOption import FuzzingOption

db = app.config['db']

#Fuzzing Job Status
db.session.add(FuzzingJobState('Queued'))           #DO NOT CHANGE
db.session.add(FuzzingJobState('Allocated'))        #DO NOT CHANGE
db.session.add(FuzzingJobState('Active'))           #DO NOT CHANGE
db.session.add(FuzzingJobState('Completed'))        #DO NOT CHANGE
db.session.add(FuzzingJobState('Paused'))           #DO NOT CHANGE
db.session.add(FuzzingJobState('Failed'))           #DO NOT CHANGE
db.session.add(FuzzingJobState('Reserved'))         #DO NOT CHANGE

#Fuzzing Option
field_type = FuzzingOptionType("FIELD")             #DO NOT CHANGE
file_type = FuzzingOptionType("FILE")               #DO NOT CHANGE
list_type = FuzzingOptionType("LIST")               #DO NOT CHANGE
checkbox_type = FuzzingOptionType("CHECKBOX")       #DO NOT CHANGE
db.session.add(field_type)
db.session.add(file_type)
db.session.add(list_type)
db.session.add(checkbox_type)


#Platforms
any_plat = FuzzingPlatform('Any')
linux_plat = FuzzingPlatform('Linux')
windows_plat = FuzzingPlatform('Windows')
macos_plat = FuzzingPlatform('macOS')
db.session.add(any_plat)
db.session.add(linux_plat)
db.session.add(windows_plat)
db.session.add(macos_plat)

#Architectures
any_arch = FuzzingArch('Any')
x64_arch = FuzzingArch('x86_64')
db.session.add(any_arch)
db.session.add(x64_arch)

#Options
input_dir = FuzzingOption('input_dir', field_type)
timeout = FuzzingOption('timeout', field_type)
fuzzer_args = FuzzingOption('fuzzer_args', field_type)
target_args = FuzzingOption('target_args', field_type)
db.session.add(input_dir)
db.session.add(timeout)
db.session.add(fuzzer_args)
db.session.add(target_args)

#Fuzzing Engines
db.session.add(
    FuzzingEngine("afl", "afl-fuzz", linux_plat, x64_arch, [input_dir, timeout, fuzzer_args, target_args])
)

#Fuzzing Targets
db.session.add(FuzzingTarget('zipinfo', "/usr/bin/zipinfo", linux_plat, x64_arch))

#Fuzzing Script
db.session.add(FuzzingScript('test-script',
'''<?xml version="1.0"?>
<test>
    <something>go</something>
</test>
'''))



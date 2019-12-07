# pretty print qt type value
# "Lekensteyn/qt5printers" github project needed be cloned into "~/.config/gdb/"
python
import sys, os.path
sys.path.insert(0, os.path.expanduser('~/.config/gdb'))
import qt5printers
qt5printers.register_printers(gdb.current_objfile())
end

# hexdump specified memory block
define hexdump
dump memory /tmp/dump.bin $arg0 $arg0+$arg1
shell hexdump -C /tmp/dump.bin
end

# alias for above hexdump
define hd
dump memory /tmp/dump.bin $arg0 $arg0+$arg1
shell hexdump -C /tmp/dump.bin
end

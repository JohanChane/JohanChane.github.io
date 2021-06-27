from __future__ import print_function
import ctypes, sys
import winreg

def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

program = r"D:\PortableProgramFiles\Neovim\bin\nvim-qt.exe"
menuName = "Edit with Neovim"
menuIcon = program

subKeyName = "EditWithNeovim"

def addRightClickMenu(subKey, menuCommand):
    with winreg.CreateKey(winreg.HKEY_CLASSES_ROOT, subKey) as key:
        winreg.SetValueEx(key, "", 0, winreg.REG_SZ, menuName)
        winreg.SetValueEx(key, "Icon", 0, winreg.REG_SZ, menuIcon)

    with winreg.CreateKey(winreg.HKEY_CLASSES_ROOT, subKey + "\\command") as key:
        winreg.SetValueEx(key, "", 0, winreg.REG_SZ, menuCommand)

def addRightClickMenuOnFile(menuCommand):
    subKey = "*\\shell\\" + subKeyName
    addRightClickMenu(subKey, menuCommand)

def addRightClickMenuOnDirectory(menuCommand):
    subKey = "Directory\\shell\\" + subKeyName
    addRightClickMenu(subKey, menuCommand)

def addRightClickMenuOnDirectoryBackground(menuCommand):
    subKey = "Directory\\Background\\shell\\" + subKeyName
    addRightClickMenu(subKey, menuCommand)

def deleteRegistryTree(root, subkey):
    try:
        hkey = winreg.OpenKey(root, subkey, access=winreg.KEY_ALL_ACCESS)
    except OSError:
        # subkey does not exist
        return
    while True:
        try:
            subsubkey = winreg.EnumKey(hkey, 0)
        except OSError:
            # no more subkeys
            break
        deleteRegistryTree(hkey, subsubkey)
    winreg.CloseKey(hkey)
    winreg.DeleteKey(root, subkey)

# ### main
if is_admin():
    # 将要运行的代码加到这里

    menuCommandOnFile = program + r' "%1"'
    menuCommand = program
    addRightClickMenuOnFile(menuCommandOnFile)
    addRightClickMenuOnDirectory(menuCommand)
    addRightClickMenuOnDirectoryBackground(menuCommand)

    # ### delete right click menu
    # deleteRegistryTree(winreg.HKEY_CLASSES_ROOT, '*\\shell\\' + subKeyName)
    # deleteRegistryTree(winreg.HKEY_CLASSES_ROOT, 'Directory\\shell\\' + subKeyName)
    # deleteRegistryTree(winreg.HKEY_CLASSES_ROOT, 'Directory\\Background\\shell\\' + subKeyName)
else:
    if sys.version_info[0] == 3:
        ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1)
    else:#in python2.x
        ctypes.windll.shell32.ShellExecuteW(None, u"runas", unicode(sys.executable), unicode(__file__), None, 1)


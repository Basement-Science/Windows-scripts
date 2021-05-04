# Make running ps-scripts the default action.
# Seems to be broken in builds AFTER 20H2 of Windows 10
New-PSDrive HKCR Registry HKEY_CLASSES_ROOT
Set-ItemProperty HKCR:\Microsoft.PowerShellScript.1\Shell '(Default)' 0
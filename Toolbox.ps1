<#
.NOTES

    Author         : Jhon Brandon Sepulevda Valdes @brandonsepulveda_66
    GitHub         : https://github.com/PapiBrandon66
    Version        : 1.1

    MIT License

Copyright (c) 2023 Jhon Brandon Sepulveda Valdes

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

#>



















# Importar la clase Shell32
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Shell32
{
    [DllImport("shell32.dll")]
    public static extern IntPtr ExtractIcon(IntPtr hInst, string lpszExeFileName, int nIconIndex);
}
"@

Add-Type -AssemblyName System.Windows.Forms

[System.Windows.Forms.Application]::EnableVisualStyles()


$computerEmoji = -join ([char]0xD83D, [char]0xDCBB)
$batEmoji = -join ([char]0xD83E, [char]0xDD87)  # Código Unicode para un murciélago
$poweredBy = "Powered by: Brandon Sepulveda"
$version = "1.1"

$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Toolbox Version $version $computerEmoji                                                                                                                        $poweredBy $batEmoji" 
$Form.Size = New-Object System.Drawing.Size(800, 600)
$Form.MinimumSize = New-Object System.Drawing.Size(400, 300)
$Form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen



# Obtener el icono de la computadora de este equipo
$icon = [System.Drawing.Icon]::FromHandle([Shell32]::ExtractIcon([IntPtr]::Zero, "shell32.dll", 15))

# Asignar el icono de la computadora de este equipo al formulario
$form.Icon = $icon



$Form.BackColor = [System.Drawing.Color]::black
$Form.ForeColor = [System.Drawing.Color]::Black
$Form.Font = New-Object System.Drawing.Font("Arial", 10)

# Ajustar la opacidad del formulario
$Form.Opacity = 1  # 


$TabControl = New-Object System.Windows.Forms.TabControl


$TabControl.Dock = [System.Windows.Forms.DockStyle]::Fill

$Form.MaximizeBox = $false
$Form.MinimizeBox = $false
$Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog


$computerEmoji = -join ([char]0xD83D, [char]0xDCBB)
$batEmoji = -join ([char]0xD83E, [char]0xDD87)  # Código Unicode para un murciélago
$rockEmoji = [char]::ConvertFromUtf32(0x1F918)

Write-Host "Toolbox Version 1.1 $computerEmoji" -ForegroundColor green
Write-Host "Hecho por Brandon Sepulveda $batEmoji" -ForegroundColor green




# Sección "Informacion del Sistema"
$TabPage_InfoSistema = New-Object System.Windows.Forms.TabPage
$TabPage_InfoSistema.Text = "Informacion del Sistema" 
$TabPage_InfoSistema.BackColor =  [System.Drawing.Color]::Black  # Cambiar a negro


$Label_InfoSistema = New-Object System.Windows.Forms.Label
$Label_InfoSistema.Text = "Informacion del Sistema:"
$Label_InfoSistema.Location = New-Object System.Drawing.Point(50, 20)
$Label_InfoSistema.Size = New-Object System.Drawing.Size(300, 20)
$Label_InfoSistema.ForeColor = [System.Drawing.Color]::White
$TabPage_InfoSistema.Controls.Add($Label_InfoSistema)
$Label_InfoSistema.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)


$TextBox_InfoSistema = New-Object System.Windows.Forms.TextBox
$TextBox_InfoSistema.Multiline = $true
$TextBox_InfoSistema.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
$TextBox_InfoSistema.Location = New-Object System.Drawing.Point(50, 50)
$TextBox_InfoSistema.Size = New-Object System.Drawing.Size(710, 420)
$TextBox_InfoSistema.AutoSize = $true
$TextBox_InfoSistema.ForeColor = [System.Drawing.Color]::Black
$TextBox_InfoSistema.BackColor = [System.Drawing.Color]::White
$TextBox_InfoSistema.ReadOnly = $true
$TabPage_InfoSistema.Controls.Add($TextBox_InfoSistema)


# Obtener informacion del sistema
$osVersion = (Get-WmiObject Win32_OperatingSystem).Caption
$osArchitecture = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
$ramInstalled = (Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory
$ramInstalledGB = [math]::Round($ramInstalled / 1GB, 2)
$diskCapacity = (Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'").Size
$diskFreeSpace = (Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'").FreeSpace
$diskCapacityGB = [math]::Round($diskCapacity / 1GB, 2)
$diskFreeSpaceGB = [math]::Round($diskFreeSpace / 1GB, 2)


# Obtener información del procesador
$processor = Get-WmiObject Win32_Processor
$processorName = $processor.Name

# Calcular el estado del disco como porcentaje
$diskUsagePercentage = (($diskCapacity - $diskFreeSpace) / $diskCapacity) * 100

# Obtener información S.M.A.R.T. del disco duro
$smartInfo = Get-WmiObject -Namespace "root\wmi" -Class MSStorageDriver_FailurePredictStatus

# Verificar si se obtuvo información S.M.A.R.T. correctamente
if ($smartInfo) {
    # Calcular el estado del disco como porcentaje
    $diskCapacity = (Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'").Size
    $diskFreeSpace = (Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'").FreeSpace
    $diskUsagePercentage = (($diskCapacity - $diskFreeSpace) / $diskCapacity) * 100

    

    # Estado de salud del disco basado en el atributo 5 (Reallocated Sectors Count)
    $reallocatedSectors = $smartInfo.PredictFailure -band 0x05
    if ($reallocatedSectors) {
        $diskHealthMessageSmart = "Prestar atencion (Reallocated Sectors Count alto)"
    } else {
        $diskHealthMessageSmart = "Bueno"
    }
    
    # Agregar información S.M.A.R.T. al texto del sistema
    $systemInfo += "Estado de Salud del Disco Duro (S.M.A.R.T.): $diskHealthMessageSmart`r`n"
} else {
    # Si no se obtuvo información S.M.A.R.T., mostrar un mensaje
    $systemInfo += "No se pudo obtener informacion S.M.A.R.T. del disco duro`r`n"
}

# Obtener la fecha de instalación del sistema operativo
$osInstallDate = (Get-WmiObject Win32_OperatingSystem).InstallDate

# Convertir la fecha de instalación a un formato legible
$osInstallDate = [Management.ManagementDateTimeConverter]::ToDateTime($osInstallDate)




$systemInfo = "Version de Windows: $osVersion`r`n"
$systemInfo += "Procesador: $processorName`r`n"
$systemInfo += "Arquitectura del Sistema: $osArchitecture`r`n"
$systemInfo += "Fecha de Instalacion del Sistema: $osInstallDate`r`n"
$systemInfo += "RAM Instalada: $ramInstalledGB GB`r`n"
$systemInfo += "Capacidad del Disco Duro: $diskCapacityGB GB`r`n"
$systemInfo += "Espacio Libre en Disco Duro: $diskFreeSpaceGB GB`r`n"
$systemInfo += "Estado del Disco Duro: $($diskUsagePercentage.ToString("F2"))% usado`r`n"
$systemInfo += "Estado de Salud del Disco Duro (S.M.A.R.T.): $diskHealthMessageSmart`r`n"



# Obtener información de las memorias RAM
$ramModules = Get-WmiObject Win32_PhysicalMemory
foreach ($module in $ramModules) {
    $speedMHz = $module.Speed
    $capacityBytes = $module.Capacity
    $capacityGB = [math]::Round($capacityBytes / 1GB, 2)
    $deviceLocator = $module.DeviceLocator
    $memoryType = $module.MemoryType
    $manufacturer = $module.Manufacturer  # Obtener la marca de la memoria RAM

    $memoryTypeString = ""
switch ($memoryType) {
    20 { $memoryTypeString = "DDR" }
    21 { $memoryTypeString = "DDR2" }
    24 { $memoryTypeString = "DDR3" }
    26 { $memoryTypeString = "DDR4" }
    default { $memoryTypeString = "Otro" }
}

    $systemInfo += "Memoria RAM - Marca: $manufacturer, Slot: $deviceLocator, Tipo: $memoryTypeString, Capacidad: $capacityGB GB, Velocidad: $speedMHz MHz`r`n"
}


# Obtener información adicional del sistema
$computerSystem = Get-WmiObject Win32_ComputerSystem
$modeloEquipo = $computerSystem.Model
$marcaEquipo = $computerSystem.Manufacturer


# Obtener información de la BIOS
$bios = Get-WmiObject Win32_BIOS
$versionBIOS = $bios.SMBIOSBIOSVersion
$serialFabrica = $bios.SerialNumber

$systemInfo += "Modelo del Equipo: $modeloEquipo`r`n"
$systemInfo += "Marca del Equipo: $marcaEquipo`r`n"
$systemInfo += "Version de la BIOS: $versionBIOS`r`n"
$systemInfo += "Serial de Fabrica: $serialFabrica`r`n"

# Obtener información de la temperatura de la CPU
$temperatureInfo = Get-WmiObject -Namespace "root\WMI" -Class MSAcpi_ThermalZoneTemperature

# Verificar si se encontró información de la temperatura de la CPU
# Verificar si se encontró información de la temperatura de la CPU
if ($temperatureInfo) {
    $temperatureCelsius = ($temperatureInfo.CurrentTemperature[0] - 2732) / 10.0
    $systemInfo += "Temperatura de la CPU: $($temperatureCelsius)C`r`n"
} else {
    $systemInfo += "No se encontro informacion de la temperatura de la CPU`r`n"
}

# Obtener información de la GPU
$gpuInfo = Get-WmiObject Win32_VideoController

# Verificar si se encontró información de la GPU
if ($gpuInfo.Count -gt 0) {
    $systemInfo += "Informacion de la GPU:`r`n"
    
    # Iterar a través de las GPUs encontradas
    foreach ($gpu in $gpuInfo) {
        # Obtener el nombre y la memoria de la GPU
        $gpuName = $gpu.Name
        $gpuMemory = if ($gpu.AdapterRAM) { [math]::Round($gpu.AdapterRAM / 1MB) } else { 0 }
        
        # Agregar información de la GPU al texto del sistema
        $systemInfo += "Nombre de la GPU: $gpuName`r`n"
        $systemInfo += "Memoria de la GPU: ${gpuMemory} MB`r`n"
    }
} else {
    $systemInfo += "No se encontro informacion de la GPU`r`n"
}




# Establecer el texto en el cuadro de texto
$TextBox_InfoSistema.Text = $systemInfo

# Agregar la pestaña "Información del Sistema" al control TabControl
$TabControl.TabPages.Add($TabPage_InfoSistema)


# Actualizar el contenido del cuadro de texto
$TextBox_InfoSistema.Text = $systemInfo



#sección Apps

$TabPage_Apps = New-Object System.Windows.Forms.TabPage
$TabPage_Apps.Text = "Apps"
$TabPage_Apps.BackColor = [System.Drawing.Color]::Black  # Cambiar a negro

$Label_APPS = New-Object System.Windows.Forms.Label
$Label_APPS.Text = "Aplicaciones:"
$Label_APPS.Location = New-Object System.Drawing.Point(150, 20)
$Label_APPS.Size = New-Object System.Drawing.Size(300, 20)
$Label_APPS.ForeColor = [System.Drawing.Color]::White
$TabPage_APPS.Controls.Add($Label_APPS)
$Label_APPS.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)

$ListBox_Apps = New-Object System.Windows.Forms.CheckedListBox
$ListBox_Apps.Location = New-Object System.Drawing.Point(150, 40)
$ListBox_Apps.Size = New-Object System.Drawing.Size(500, 400)

# Agrega las aplicaciones a la lista

# Agregar elementos al ListBox sin mostrar la salida en el terminal
[void]$ListBox_Apps.Items.Add("Lenovo System Update")
[void]$ListBox_Apps.Items.Add("Hard Disk Sentinel Professional")
[void]$ListBox_Apps.Items.Add("TeamViewer")
[void]$ListBox_Apps.Items.Add("Herramienta de Soporte de Desinstalacion de Microsoft 365")
[void]$ListBox_Apps.Items.Add("Intel Driver & Support Assistant (Intel DSA)")
[void]$ListBox_Apps.Items.Add("Anydesk")
[void]$ListBox_Apps.Items.Add("AIDA64")
[void]$ListBox_Apps.Items.Add("Dell Command Update")
[void]$ListBox_Apps.Items.Add("Lenovo Vantage")
[void]$ListBox_Apps.Items.Add("HP PC Hardware Diagnostics Windows")
[void]$ListBox_Apps.Items.Add("HP Smart")
[void]$ListBox_Apps.Items.Add("MyASUS")
[void]$ListBox_Apps.Items.Add("Rufus")
[void]$ListBox_Apps.Items.Add("Ventoy")
[void]$ListBox_Apps.Items.Add("Google Chrome")
[void]$ListBox_Apps.Items.Add("7-Zip")
[void]$ListBox_Apps.Items.Add("WinRAR")
[void]$ListBox_Apps.Items.Add("Notepad++")
[void]$ListBox_Apps.Items.Add("Visual Studio Code")
[void]$ListBox_Apps.Items.Add("Brave Browser")
[void]$ListBox_Apps.Items.Add("WhatsApp")
[void]$ListBox_Apps.Items.Add("Discord")
[void]$ListBox_Apps.Items.Add("PowerShell")
[void]$ListBox_Apps.Items.Add("Microsoft PowerToys")
[void]$ListBox_Apps.Items.Add("Windows Terminal")



$Button_DownloadExecute = New-Object System.Windows.Forms.Button
$Button_DownloadExecute.FlatStyle = 'Flat'
$Button_DownloadExecute.Text = "Descargar y Ejecutar"
$Button_DownloadExecute.Location = New-Object System.Drawing.Point(250, 450)
$Button_DownloadExecute.Size = New-Object System.Drawing.Size(300, 40)
$Button_DownloadExecute.ForeColor =  [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")



$Button_DownloadExecute.Add_Click({
    $AppsToDownload = @()
    foreach ($app in $ListBox_Apps.CheckedItems) {
        switch ($app) {
            "Lenovo System Update" {
                $AppsToDownload += @{
                    Name = $app
                    URL = "https://download.lenovo.com/pccbbs/thinkvantage_en/system_update_5.08.02.25.exe"
                    Extension = ".exe"
                }
            }
            "Hard Disk Sentinel Professional" {
                # Ejecutar winget para instalar Hard Disk Sentinel con aceptación automática de términos
                try {
                    Start-Process powershell -ArgumentList "-NoExit -Command `"winget install XPDNXG5333CSVK --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("Hard Disk Sentinel instalado correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar Hard Disk Sentinel: $_", "Error de Instalacion")
                }
            }
            
            
            "TeamViewer" {
                $AppsToDownload += @{
                    Name = $app
                    URL = "https://download.teamviewer.com/download/TeamViewer_Setup_x64.exe"
                    Extension = ".exe"
                }
            }
            "Herramienta de Soporte de Desinstalacion de Microsoft 365" {
                $AppsToDownload += @{
                    Name = $app
                    URL = "https://aka.ms/SaRA-officeUninstallFromPC"
                    Extension = ".exe"
                }
            }
            "Intel Driver & Support Assistant (Intel DSA)" {
                $AppsToDownload += @{
                    Name = $app
                    URL = "https://dsadata.intel.com/installer"
                    Extension = ".exe"
                }
            }

            "Anydesk" {
                # Ejecutar winget para instalar AnyDesk con aceptación automática de términos
                try {
                    Start-Process -FilePath "winget" -ArgumentList "install AnyDeskSoftwareGmbH.AnyDesk --accept-package-agreements" -Wait -NoNewWindow
                    [System.Windows.Forms.MessageBox]::Show("AnyDesk instalado correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar AnyDesk: $_", "Error de Instalacion")
                }
            }

            "AIDA64" {
                # Ejecutar winget para instalar AnyDesk con aceptación automática de términos
                try {
                    # Ejecutar winget para instalar AIDA64 Extreme Edition
                     Start-Process powershell -ArgumentList "-NoExit -Command `"winget install FinalWire.AIDA64.Extreme --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("AIDA64 Extreme Edition instalado correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar AIDA64 Extreme Edition: $_", "Error de Instalacion")
                }
            }

            "Dell Command Update" {
                # Ejecutar winget para instalar AnyDesk con aceptación automática de términos
                try {
                    # Ejecutar winget para instalar AIDA64 Extreme Edition
                     Start-Process powershell -ArgumentList "-NoExit -Command `"winget install Dell.CommandUpdate --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("Dell command Update instalado correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar Dell command Update: $_", "Error de Instalacion")
                }
            }

            "Lenovo Vantage" {
                # Ejecutar winget para instalar AnyDesk con aceptación automática de términos
                try {
                    # Ejecutar winget para instalar AIDA64 Extreme Edition
                     Start-Process powershell -ArgumentList "-NoExit -Command `"winget install 9WZDNCRFJ4MV --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("Lenovo Vantage instalado correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar Lenovo Vantage: $_", "Error de Instalación")
                }
            }

            "HP PC Hardware Diagnostics Windows" {
                # Ejecutar winget para instalar AnyDesk con aceptación automática de términos
                try {
                    # Ejecutar winget para instalar AIDA64 Extreme Edition
                     Start-Process powershell -ArgumentList "-NoExit -Command `"winget install 9P4PNDG7L782 --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("HP PC Hardware Diagnostics Windows instalado correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar HP PC Hardware Diagnostics Windows: $_", "Error de Instalacion")
                }
            }

            "HP Smart" {
                # Ejecutar winget para instalar AnyDesk con aceptación automática de términos
                try {
                    # Ejecutar winget para instalar AIDA64 Extreme Edition
                     Start-Process powershell -ArgumentList "-NoExit -Command `"winget install 9WZDNCRFHWLH --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("HP Smart instalado correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar HP Smart: $_", "Error de Instalacion")
                }
            }

            "MyASUS" {
                # Ejecutar winget para instalar AnyDesk con aceptación automática de términos
                try {
                    # Ejecutar winget para instalar MyAsus Extreme Edition
                     Start-Process powershell -ArgumentList "-NoExit -Command `"winget install 9N7R5S6B0ZZH --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("MyASUS instalado correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar MyASUS: $_", "Error de Instalacion")
                }
            }

            "Rufus" {
                # Ejecutar winget para instalar Hard Disk Sentinel con aceptación automática de términos
                try {
                    Start-Process powershell -ArgumentList "-NoExit -Command `"winget install 9PC3H3V7Q9CH --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("Rufus correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar Rufus: $_", "Error de Instalación")
                }
            }

            "Ventoy" {
                # Ejecutar winget para instalar Hard Disk Sentinel con aceptación automática de términos
                try {
                    Start-Process powershell -ArgumentList "-NoExit -Command `"winget install Ventoy.Ventoy --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("Ventoy  correctamente.", "Instalación Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar Ventoy: $_", "Error de Instalación")
                }
            }

            "Google Chrome" {
                # Ejecutar winget para instalar Hard Disk Sentinel con aceptación automática de términos
                try {
                    Start-Process powershell -ArgumentList "-NoExit -Command `"winget install Google.Chrome --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("Google Chromel instalado correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar Google Chrome: $_", "Error de Instalacion")
                }
            }
            
            "7-Zip" {
                # Ejecutar winget para instalar Hard Disk Sentinel con aceptación automática de términos
                try {
                    Start-Process powershell -ArgumentList "-NoExit -Command `"winget install 7zip.7zip --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("7-Zip instalado correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar 7-Zip: $_", "Error de Instalacion")
                }
            }

            "WinRAR" {
                # Ejecutar winget para instalar Hard Disk Sentinel con aceptación automática de términos
                try {
                    Start-Process powershell -ArgumentList "-NoExit -Command `"winget install RARLab.WinRAR --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("WinRAR instalado correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar WinRAR: $_", "Error de Instalacion")
                }
            }

            "Notepad++" {
                # Ejecutar winget para instalar Hard Disk Sentinel con aceptación automática de términos
                try {
                    Start-Process powershell -ArgumentList "-NoExit -Command `"winget install Notepad++.Notepad++ --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("Notepad++ instalado correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar Notepad++ $_", "Error de Instalacion")
                }
            }
            
              
            "Brave Browser" {
                # Ejecutar winget para instalar Hard Disk Sentinel con aceptación automática de términos
                try {
                    Start-Process powershell -ArgumentList "-NoExit -Command `"winget install XP8C9QZMS2PC1T --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("Brave Browser instalado correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar Brave Browser $_", "Error de Instalacion")
                }
            }
                
            "WhatsApp" {
                # Ejecutar winget para instalar Hard Disk Sentinel con aceptación automática de términos
                try {
                    Start-Process powershell -ArgumentList "-NoExit -Command `"winget install 9NKSQGP7F2NH --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("WhatsApp instalado correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar WhatsApp $_", "Error de Instalacion")
                }
            }

            "Discord" {
                # Ejecutar winget para instalar Hard Disk Sentinel con aceptación automática de términos
                try {
                    Start-Process powershell -ArgumentList "-NoExit -Command `"winget install Discord.Discord --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("Discord instalado correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar Discord $_", "Error de Instalacion")
                }
            }

            "PowerShell" {
                # Ejecutar winget para instalar Hard Disk Sentinel con aceptación automática de términos
                try {
                    Start-Process powershell -ArgumentList "-NoExit -Command `"winget install  Microsoft.PowerShell --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("PowerShell instalado correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar PowerShell $_", "Error de Instalacion")
                }
            }

            "Microsoft PowerToys" {
                # Ejecutar winget para instalar Hard Disk Sentinel con aceptación automática de términos
                try {
                    Start-Process powershell -ArgumentList "-NoExit -Command `"winget install  XP89DCGQ3K6VLD --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("Microsoft PowerToys instalado correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar Microsoft PowerToys $_", "Error de Instalacion")
                }
            }

            "Windows Terminal" {
                # Ejecutar winget para instalar Hard Disk Sentinel con aceptación automática de términos
                try {
                    Start-Process powershell -ArgumentList "-NoExit -Command `"winget install 9N0DX20HK701 --accept-package-agreements`""
                    [System.Windows.Forms.MessageBox]::Show("Windows Terminal instalado correctamente.", "Instalacion Completada")
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Error al instalar Windows Terminal $_", "Error de Instalacion")
                }
            }

        }
    }

    if ($AppsToDownload.Count -gt 0) {
        foreach ($app in $AppsToDownload) {  
            $OutputPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("Desktop"), "$($app.Name)$($app.Extension)")
            Invoke-WebRequest -Uri $app.URL -OutFile $OutputPath
            if ($app.Extension -eq ".bat") {
                $batContent = Get-Content -Path $OutputPath
                Set-Content -Path $OutputPath -Value $batContent -Encoding ASCII
            }
            Start-Process -FilePath $OutputPath
        }
        [System.Windows.Forms.MessageBox]::Show("Descarga y ejecucion completadas.", "Completado")
    } else {
        [System.Windows.Forms.MessageBox]::Show("Por favor, selecciona al menos una aplicacion para descargar y ejecutar.", "Error")
    }
})

$TabPage_Apps.Controls.Add($ListBox_Apps)
$TabPage_Apps.Controls.Add($Button_DownloadExecute)
$TabControl.Controls.Add($TabPage_Apps)






# Crear una nueva pestaña para la sección de Restauración y Verificación
$TabPage_Restauracion = New-Object System.Windows.Forms.TabPage
$TabPage_Restauracion.Text = "Restauracion y Verificacion"
$TabPage_Restauracion.BackColor = [System.Drawing.Color]::Black  # Cambiar a negro

# Crear una etiqueta para el título "Verificar y Reparar"
$Label_VerificarReparar = New-Object System.Windows.Forms.Label
$Label_VerificarReparar.Text = "Verificar y Reparar :"
$Label_VerificarReparar.Location = New-Object System.Drawing.Point(44, 20)  # Ajusta la posición horizontal y vertical según sea necesario
$Label_VerificarReparar.Size = New-Object System.Drawing.Size(150, 20)  # Ajusta el ancho y alto de la etiqueta según sea necesario
$Label_VerificarReparar.ForeColor = [System.Drawing.Color]::White  # Color del texto
$Label_VerificarReparar.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter  # Alineación del texto al centro
$Label_VerificarReparar.Font = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Bold)  # Establecer la fuente en negrita

# Agregar la etiqueta del título a la pestaña
$TabPage_Restauracion.Controls.Add($Label_VerificarReparar)
$Button_CrearRestauracion = New-Object System.Windows.Forms.Button
$Button_CrearRestauracion.FlatStyle = 'Flat'
$Button_CrearRestauracion.Text = "Crear Punto de Restauracion"
$Button_CrearRestauracion.Location = New-Object System.Drawing.Point(50, 60)
$Button_CrearRestauracion.Size = New-Object System.Drawing.Size(150, 50)
$Button_CrearRestauracion.ForeColor   = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$Button_VerificarArchivos = New-Object System.Windows.Forms.Button
$Button_VerificarArchivos.FlatStyle = 'Flat'
$Button_VerificarArchivos.Text = "Verificar y Reparar Archivos del Sistema"
$Button_VerificarArchivos.Location = New-Object System.Drawing.Point(50, 120)
$Button_VerificarArchivos.Size = New-Object System.Drawing.Size(150, 50)
$Button_VerificarArchivos.ForeColor =  [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$Button_BSOD_Info = New-Object System.Windows.Forms.Button
$Button_BSOD_Info.FlatStyle = 'Flat'
$Button_BSOD_Info.Text = "Informacion de Pantallazos Azules"
$Button_BSOD_Info.Location = New-Object System.Drawing.Point(50, 180) 
$Button_BSOD_Info.Size = New-Object System.Drawing.Size(150, 50)
$Button_BSOD_Info.ForeColor =  [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

# Crear un botón para generar el informe de la batería
$Button_BatteryReport = New-Object System.Windows.Forms.Button
$Button_BatteryReport.FlatStyle = 'Flat'
$Button_BatteryReport.Text = "Generar Informe de Bateria"
$Button_BatteryReport.Location = New-Object System.Drawing.Point(50, 240)  # Ajusta la posición vertical según sea necesario
$Button_BatteryReport.Size = New-Object System.Drawing.Size(150, 50)
$Button_BatteryReport.ForeColor =  [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

# Crear botón para obtener información de drivers
$Button_InfoDrivers = New-Object System.Windows.Forms.Button
$Button_InfoDrivers.FlatStyle = 'Flat'
$Button_InfoDrivers.Text = "Informacion de Drivers"
$Button_InfoDrivers.Location = New-Object System.Drawing.Point(50, 300)
$Button_InfoDrivers.Size = New-Object System.Drawing.Size(150, 50)
$Button_InfoDrivers.ForeColor   = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")


# Botón para reparar la red
$Button_RepararRed = New-Object System.Windows.Forms.Button
$Button_RepararRed.FlatStyle = 'Flat'
$Button_RepararRed.Text = "Reparar Red"
$Button_RepararRed.Location = New-Object System.Drawing.Point(50, 360)  # Ajusta la posición según sea necesario
$Button_RepararRed.Size = New-Object System.Drawing.Size(150, 50)
$Button_RepararRed.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")
$Button_RepararRed.Font = New-Object System.Drawing.Font("Arial",9 )  # Establecer el tamaño de la letra


# Crear una etiqueta para el título "Limpieza y Optimizacion"
$Label_Title = New-Object System.Windows.Forms.Label
$Label_Title.Text = "Limpieza y Optimizacion :"
$Label_Title.Location = New-Object System.Drawing.Point(490, 20)  # Ajusta la posición horizontal y vertical según sea necesario
$Label_Title.Size = New-Object System.Drawing.Size(200, 20)  # Ajusta el ancho y alto de la etiqueta según sea necesario
$Label_Title.ForeColor = [System.Drawing.Color]::White  # Color del texto
$Label_Title.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter  # Alineación del texto al centro
$Label_Title.Font = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Bold)

# Agregar la etiqueta del título a la pestaña
$TabPage_Restauracion.Controls.Add($Label_Title)

# Agregar el menú desplegable de limpieza
$Button_Menu_Limpieza = New-Object System.Windows.Forms.Button
$Button_Menu_Limpieza.FlatStyle = 'Flat'
$Button_Menu_Limpieza.Text = "Limpieza"
$Button_Menu_Limpieza.Location = New-Object System.Drawing.Point(500, 60)
$Button_Menu_Limpieza.Size = New-Object System.Drawing.Size(200, 40)
$Button_Menu_Limpieza.ForeColor =  [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")


# Manejadores de eventos para los botones
$Button_CrearRestauracion.Add_Click({
    # Crear un punto de restauración
    $description = "Punto de restauracion creado por Toolbox "
    $restorePointType = "MODIFY_SETTINGS"
    Checkpoint-Computer -Description $description -RestorePointType $restorePointType

    # Mostrar un mensaje para informar al usuario que se ha creado el punto de restauración
    [System.Windows.Forms.MessageBox]::Show("Se ha creado un punto de restauracion.", "Punto de Restauracion Creado")
})

$Button_VerificarArchivos.Add_Click({
    try {
        # Verificar si el script se está ejecutando como administrador
        if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            [System.Windows.Forms.MessageBox]::Show("Debes ejecutar el script como administrador para verificar y reparar archivos del sistema.", "Error de Permiso")
            return
        }

        # Abrir una nueva instancia de PowerShell y ejecutar los comandos en secuencia
        $script = @"
        chkdsk;
        Start-Sleep -Seconds 1;
        sfc /scannow;
        Start-Sleep -Seconds 1;
        DISM.exe /Online /Cleanup-image /Scanhealth;
        Start-Sleep -Seconds 1;
        DISM.exe /Online /Cleanup-image /Restorehealth;
        Start-Sleep -Seconds 1;
        Dism.exe /Online /Cleanup-Image /startComponentCleanup;
"@
        Start-Process powershell -ArgumentList "-NoExit", "-Command", $script

        # Mostrar un mensaje para informar al usuario que la verificación y reparación de archivos se ha iniciado
        [System.Windows.Forms.MessageBox]::Show("Verificacion y reparacion de archivos iniciada.", "Proceso Iniciado")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error al verificar y reparar archivos del sistema:`n$error", "Error")
    }
})


$Button_BSOD_Info.Add_Click({
    # Define la URL de descarga de BlueScreenView.zip
    $Url = "https://www.nirsoft.net/utils/bluescreenview.zip"
    
    # Define la ruta de destino para la descarga y la extracción
    $ZipPath = Join-Path $env:TEMP "bluescreenview.zip"
    $ExtractPath = Join-Path $env:TEMP "BlueScreenView"
    
    # Descarga el archivo zip
    try {
        Invoke-WebRequest -Uri $Url -OutFile $ZipPath
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error al descargar BlueScreenView: $_", "Error de Descarga")
        return
    }
    
    # Extrae el contenido del archivo zip
    try {
        Expand-Archive -Path $ZipPath -DestinationPath $ExtractPath -Force
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error al extraer BlueScreenView: $_", "Error de Extracción")
        return
    }
    
    # Ejecuta BlueScreenView.exe
    $ExePath = Join-Path $ExtractPath "BlueScreenView.exe"
    if (Test-Path -Path $ExePath) {
        try {
            Start-Process -FilePath $ExePath
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error al ejecutar BlueScreenView: $_", "Error de Ejecución")
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("No se encontró BlueScreenView.exe en la carpeta extraída.", "Archivo No Encontrado")
    }
})

# Agregar un controlador de eventos para el clic del botón
$Button_BatteryReport.Add_Click({
    try {
        # Ejecutar el comando para generar el informe de la batería
        $batteryReportCommand = "powercfg /batteryreport /output `"C:\battery_report.html`""
        Invoke-Expression -Command $batteryReportCommand

        # Mostrar un mensaje emergente con la ubicación del informe
        [System.Windows.Forms.MessageBox]::Show("El informe de la bateria se ha generado correctamente en C:\battery_report.html", "Informe Generado")

    } catch {
        # Mostrar un mensaje de error si ocurre algún problema
        [System.Windows.Forms.MessageBox]::Show("Error al generar el informe de la bateria:`n$error", "Error")
    }

})


$Button_InfoDrivers.Add_Click({
# Obtener información de los controladores del sistema
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Get-WmiObject -Query 'SELECT * FROM Win32_SystemDriver' | Select-Object DisplayName, Description, PathName, StartMode, State, Status | Out-File -FilePath 'informacion_controladores.txt'; Invoke-Item -Path 'informacion_controladores.txt'"

})


$ContextMenu_Limpieza = New-Object System.Windows.Forms.ContextMenuStrip

$MenuItem_Temporales = New-Object System.Windows.Forms.ToolStripMenuItem
$MenuItem_Temporales.Text = "Eliminar archivos temporales"
$MenuItem_Temporales.Add_Click({
    try {
        $tempFolderPath = "C:\Windows\Temp"

        # Elimina todos los archivos y carpetas en la carpeta de archivos temporales
        Remove-Item -Path "$tempFolderPath\*" -Force -Recurse

        [System.Windows.Forms.MessageBox]::Show("Archivos temporales eliminados.", "Completado")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error al eliminar archivos temporales:`n$error", "Error")
    }
})

$MenuItem_CacheActualizacion = New-Object System.Windows.Forms.ToolStripMenuItem
$MenuItem_CacheActualizacion.Text = "Eliminar cache de actualizacion"
$MenuItem_CacheActualizacion.Add_Click({
    Stop-Service -Name "wuauserv" -Force
    Stop-Service -Name "UsoSvc" -Force
    Remove-Item -Path "$env:WINDIR\SoftwareDistribution" -Force -Recurse
    New-Item -Path "$env:WINDIR\SoftwareDistribution" -ItemType Directory
    Start-Service -Name "wuauserv"
    Start-Service -Name "UsoSvc"
    [System.Windows.Forms.MessageBox]::Show("Cache de actualizacion eliminado.", "Completado")
})

# Nueva opción: Limpiar caché DNS
$MenuItem_LimpiarCacheDNS = New-Object System.Windows.Forms.ToolStripMenuItem
$MenuItem_LimpiarCacheDNS.Text = "Limpiar cache DNS"
$MenuItem_LimpiarCacheDNS.Add_Click({
    Invoke-Expression -Command "ipconfig /flushdns 2>&1"
    if ($LASTEXITCODE -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Cache DNS limpiado correctamente.", "Completado")
    } else {
        [System.Windows.Forms.MessageBox]::Show("Error al limpiar el cache DNS.", "Error")
    }
})

# Nueva opción: Limpiar y optimizar RAM
$MenuItem_LimpiarRAM = New-Object System.Windows.Forms.ToolStripMenuItem
$MenuItem_LimpiarRAM.Text = "Limpiar y optimizar RAM"
$MenuItem_LimpiarRAM.Add_Click({
    try {
        # Descargar el archivo ZIP
        $zipUrl = "https://download.sysinternals.com/files/RAMMap.zip"
        $downloadPath = "$env:TEMP\RAMMap.zip"
        $extractPath = "$env:TEMP\RAMMap"

        Invoke-WebRequest -Uri $zipUrl -OutFile $downloadPath

        # Descomprimir el archivo ZIP
        Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force

        # Ruta al ejecutable RAMMap.exe
        $executablePath = Join-Path $extractPath "RAMMap.exe"

        # Ejecutar RAMMap.exe
        Start-Process -FilePath $executablePath

        [System.Windows.Forms.MessageBox]::Show("RAMMap ejecutado correctamente", "Completado")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error al limpiar y optimizar la RAM:`n$error", "Error")
    }
})

$ContextMenu_Limpieza.Items.AddRange(@($MenuItem_Temporales, $MenuItem_CacheActualizacion, $MenuItem_LimpiarCacheDNS, $MenuItem_LimpiarRAM))
$Button_Menu_Limpieza.Add_Click({
    $menuLocation = $Button_Menu_Limpieza.PointToScreen([System.Drawing.Point]::new(0, $Button_Menu_Limpieza.Height))
    $menuLocation.X += ($Button_Menu_Limpieza.Width - $ContextMenu_Limpieza.Width) / 2
    $ContextMenu_Limpieza.Show($menuLocation)
})


# Agregar un controlador de eventos para el clic del botón "Reparar Red"
$Button_RepararRed.Add_Click({
    # Ejecutar los comandos para reparar la red
    netsh winsock reset
    netsh int ip reset
    ipconfig /release
    ipconfig /renew

    # Mostrar un mensaje al usuario una vez que se hayan ejecutado los comandos
    [System.Windows.Forms.MessageBox]::Show("Proceso de reparación de red completado.", "Reparación de Red")
})
# Agregar botones a la pestaña
$TabPage_Restauracion.Controls.Add($Button_CrearRestauracion)
$TabPage_Restauracion.Controls.Add($Button_VerificarArchivos)
$TabPage_Restauracion.Controls.Add($Button_BSOD_Info)
$TabPage_Restauracion.Controls.Add($Button_BatteryReport)
$TabPage_Restauracion.Controls.Add($Button_InfoDrivers)
$TabPage_Restauracion.Controls.Add($Button_Menu_Limpieza)
$TabPage_Restauracion.Controls.Add($Button_RepararRed)
                            
# Agregar la pestaña "Restauración y Verificación" al control TabControl
$TabControl.TabPages.Add($TabPage_Restauracion)

# menu seleccionable
$TabPage4 = New-Object System.Windows.Forms.TabPage
$TabPage4.Text = "Tweaks y Utilidades"
$TabPage4.BackColor = [System.Drawing.Color]::Black  # Cambiar a negro

# Crear una etiqueta para el título "Mejoras S.O y Utilidades"
$Label_MejorasUtilidades = New-Object System.Windows.Forms.Label
$Label_MejorasUtilidades.Text = "Mejoras,Utilidades:"
$Label_MejorasUtilidades.Location = New-Object System.Drawing.Point(45, 20)  # Ajusta la posición horizontal y vertical según sea necesario
$Label_MejorasUtilidades.Size = New-Object System.Drawing.Size(150, 20)  # Ajusta el ancho y alto de la etiqueta según sea necesario
$Label_MejorasUtilidades.ForeColor = [System.Drawing.Color]::White  # Color del texto
$Label_MejorasUtilidades.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter  # Alineación del texto al centro
$Label_MejorasUtilidades.Font = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Bold)  # Establecer la fuente en negrita

# Agregar la etiqueta del título a la pestaña
$TabPage4.Controls.Add($Label_MejorasUtilidades)

# Botón para ejecutar Christitus
$Button_EjecutarChristitus = New-Object System.Windows.Forms.Button
$Button_EjecutarChristitus.FlatStyle = 'Flat'
$Button_EjecutarChristitus.Text = "Ejecutar Christitus"
$Button_EjecutarChristitus.Location = New-Object System.Drawing.Point(50, 50)  # Ajusta la posición según sea necesario
$Button_EjecutarChristitus.Size = New-Object System.Drawing.Size(150, 30)
$Button_EjecutarChristitus.ForeColor =  [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$Button_EjecutarChristitus.Add_Click({
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "iwr -useb https://christitus.com/win | iex" -Verb RunAs
})

$TabPage4.Controls.Add($Button_EjecutarChristitus)
# Botón para ejecutar Debloat
$Button_EjecutarDebloat = New-Object System.Windows.Forms.Button
$Button_EjecutarDebloat.FlatStyle = 'Flat'
$Button_EjecutarDebloat.Text = "Ejecutar Debloat"
$Button_EjecutarDebloat.Location = New-Object System.Drawing.Point(50, 90)  # Ajusta la posición según sea necesario
$Button_EjecutarDebloat.Size = New-Object System.Drawing.Size(150, 30)
$Button_EjecutarDebloat.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")


$Button_EjecutarDebloat.Add_Click({
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "iwr -useb https://git.io/debloat | iex" -Verb RunAs
})

$TabPage4.Controls.Add($Button_EjecutarDebloat)


# Botón para instalar Winget
$Button_InstalarWinget = New-Object System.Windows.Forms.Button
$Button_InstalarWinget.FlatStyle = 'Flat'
$Button_InstalarWinget.Text = "Instalar Winget"
$Button_InstalarWinget.Location = New-Object System.Drawing.Point(50, 130)  # Ajusta la posición según sea necesario
$Button_InstalarWinget.Size = New-Object System.Drawing.Size(150, 30)
$Button_InstalarWinget.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")


$Button_InstalarWinget.Add_Click({
    Start-Process powershell -ArgumentList "-NoExit -Command `"Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle; Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx; Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.7.3/Microsoft.UI.Xaml.2.7.x64.appx -OutFile Microsoft.UI.Xaml.2.7.x64.appx; Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx; Add-AppxPackage Microsoft.UI.Xaml.2.7.x64.appx; Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle`""
})



$TabPage4.Controls.Add($Button_InstalarWinget)

$Button_Activarwindows = New-Object System.Windows.Forms.Button
$Button_Activarwindows.FlatStyle = 'Flat'
$Button_Activarwindows.Text = "Activar Windows"
$Button_Activarwindows.Location = New-Object System.Drawing.Point(50, 170)  # Ajusta la posición según sea necesario
$Button_Activarwindows.Size = New-Object System.Drawing.Size(150, 30)
$Button_Activarwindows.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")


$Button_Activarwindows.Add_Click({
    # Obtener la clave digital usando PowerShell
    $clave = (Get-WmiObject SoftwareLicensingService | Select-Object -ExpandProperty OA3xOriginalProductKey)

    # Mostrar la clave obtenida
    Write-Host "La clave digital es: $clave"

    # Establecer la clave como predefinida
    slmgr.vbs /ipk $clave

    # Mostrar mensaje de confirmación
    Write-Host "Clave establecida como predefinida correctamente."
})

$TabPage4.Controls.Add($Button_Activarwindows)




# Botón para Ejecutar Optimizer
$Button_Optimizer = New-Object System.Windows.Forms.Button
$Button_Optimizer.FlatStyle = 'Flat'
$Button_Optimizer.Text = "Ejecutar Optimizer"
$Button_Optimizer.Location = New-Object System.Drawing.Point(50, 210)  # Ajusta la posición según sea necesario
$Button_Optimizer.Size = New-Object System.Drawing.Size(150, 30)
$Button_Optimizer.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")


# Agrega un evento al hacer clic en el botón
$Button_Optimizer.Add_Click({
    $url = "https://github.com/hellzerg/optimizer/releases/download/16.4/Optimizer-16.4.exe"
    $outputFolder = "C:\Path\To\Download"
    $outputPath = Join-Path $outputFolder "Optimizer-16.4.exe"

    # Verifica si la carpeta de destino existe, si no, la crea
    if (-not (Test-Path -Path $outputFolder -PathType Container)) {
        New-Item -ItemType Directory -Force -Path $outputFolder
    }

    try {
        Invoke-WebRequest -Uri $url -OutFile $outputPath
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error al descargar Optimizer: $_", "Error de Descarga")
        return
    }

    try {
        Start-Process -FilePath $outputPath
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error al ejecutar Optimizer: $_", "Error de Ejecución")
    }
})


$TabPage4.Controls.Add($Button_Optimizer)





# Botón para abrir menú desplegable de Windows
$Button_Menu_Windows = New-Object System.Windows.Forms.Button
$Button_Menu_Windows.FlatStyle = 'Flat'
$Button_Menu_Windows.Text = "Windows"
$Button_Menu_Windows.Location = New-Object System.Drawing.Point(50, 250)  # Ajusta la posición según sea necesario
$Button_Menu_Windows.Size = New-Object System.Drawing.Size(150, 30)
$Button_Menu_Windows.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")


## Crear menú desplegable para Windows
$ContextMenu_Windows = New-Object System.Windows.Forms.ContextMenuStrip

$MenuItem_Windows10 = New-Object System.Windows.Forms.ToolStripMenuItem
$MenuItem_Windows10.Text = "Descargar Windows 10"
$MenuItem_Windows10.Add_Click({
    $scriptBlock = {
        param($url, $outputPath)
        Invoke-WebRequest -Uri $url -OutFile $outputPath
    }
    $url = "https://software.download.prss.microsoft.com/dbazure/Win10_22H2_Spanish_x64v1.iso?t=7f287f11-a3b2-480a-83e8-95289fc65fea&e=1707175743&h=0b73f9b84704b7797d33d2501a08d3f96430baa5326f771a4c43037a05089401"
    $outputPath = "$env:USERPROFILE\Downloads\Win10_22H2_Spanish_x64v1.iso"
    Start-Job -ScriptBlock $scriptBlock -ArgumentList $url, $outputPath
})

$MenuItem_Windows11 = New-Object System.Windows.Forms.ToolStripMenuItem
$MenuItem_Windows11.Text = "Descargar Windows 11"
$MenuItem_Windows11.Add_Click({
    $scriptBlock = {
        param($url, $outputPath)
        Invoke-WebRequest -Uri $url -OutFile $outputPath 
    }
    $url = "https://software.download.prss.microsoft.com/dbazure/Win11_23H2_Spanish_x64v2.iso?t=416df54f-5470-4c05-8869-055f84a837c2&e=1707175690&h=c372071690f9670d1ab84ed20933dcb116b0b0098e6b600c797581cae5cf63f4"
    $outputPath = "$env:USERPROFILE\Downloads\Win11_23H2_Spanish_x64v2.iso"
    Start-Job -ScriptBlock $scriptBlock -ArgumentList $url, $outputPath
})

$ContextMenu_Windows.Items.AddRange(@($MenuItem_Windows10, $MenuItem_Windows11))

# Asignar menú desplegable al botón
$Button_Menu_Windows.Add_Click({
    $menuLocation = $Button_Menu_Windows.PointToScreen([System.Drawing.Point]::new(0, $Button_Menu_Windows.Height))
    $menuLocation.X += ($Button_Menu_Windows.Width - $ContextMenu_Windows.Width) / 2
    $ContextMenu_Windows.Show($menuLocation)
})

$TabPage4.Controls.Add($Button_Menu_Windows)

$TabPage4.Controls.Add($Button_Download_Windows)



Add-Type -AssemblyName System.Windows.Forms

# Función para obtener información del sistema
function ObtenerInformacionEquipo {
    $modelo = (Get-WmiObject -Class Win32_ComputerSystem).Model
    $serial = (Get-WmiObject -Class Win32_BIOS).SerialNumber
    return $modelo, $serial
}

# Crear botón para buscar drivers
$buttonBuscarDrivers = New-Object System.Windows.Forms.Button
$buttonBuscarDrivers.Location = New-Object System.Drawing.Point(50, 290)  # Ajusta la posición según sea necesario
$buttonBuscarDrivers.Size = New-Object System.Drawing.Size(150, 30)
$buttonBuscarDrivers.Text = "Buscar Drivers"
$buttonBuscarDrivers.FlatStyle = 'Flat'
$buttonBuscarDrivers.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

# Agregar evento al hacer clic en el botón
$buttonBuscarDrivers.Add_Click({
    $modelo, $serial = ObtenerInformacionEquipo
    Write-Host "Tu equipo es: $modelo, Número de serie: $serial"
    # Construir la URL con el modelo y número de serie para buscar drivers
    $url = "https://www.google.com/search?q=$modelo+$serial+drivers"
    Start-Process $url
})


$TabPage4.Controls.Add($buttonBuscarDrivers)
# Crear una etiqueta para el título "Atajo"
$Label_Atajo = New-Object System.Windows.Forms.Label
$Label_Atajo.Text = "Atajos :"
$Label_Atajo.Location = New-Object System.Drawing.Point(405, 20)  # Ajusta la posición horizontal y vertical según sea necesario
$Label_Atajo.Size = New-Object System.Drawing.Size(250, 20)  # Ajusta el ancho y alto de la etiqueta según sea necesario
$Label_Atajo.ForeColor = [System.Drawing.Color]::White  # Color del texto
$Label_Atajo.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter  # Alineación del texto al centro
$Label_Atajo.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)  # Establecer la fuente en negrita y tamaño más grande

# Agregar la etiqueta del título "Atajo" a la página
$TabPage4.Controls.Add($Label_Atajo)
# Botón para abrir la ventana de ajustes de rendimiento de Windows
$Button_AppearancePerformance = New-Object System.Windows.Forms.Button
$Button_AppearancePerformance.FlatStyle = 'Flat'
$Button_AppearancePerformance.Text = "Propiedades del Sistema"
$Button_AppearancePerformance.Location = New-Object System.Drawing.Point(500, 50)  # Ajusta la posición según sea necesario
$Button_AppearancePerformance.Size = New-Object System.Drawing.Size(250, 30)
$Button_AppearancePerformance.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")
$Button_AppearancePerformance.Font = New-Object System.Drawing.Font("Arial",9)  # Establecer el tamaño de la letra más pequeño

$Button_AppearancePerformance.Add_Click({
    # Abrir la ventana de ajustes de rendimiento de Windows
    control.exe sysdm.cpl
})


# Botón para deshabilitar la transparencia en la configuración de Windows
$Button_DeshabilitarTransparencia = New-Object System.Windows.Forms.Button
$Button_DeshabilitarTransparencia.FlatStyle = 'Flat'
$Button_DeshabilitarTransparencia.Text = "Deshabilitar Transparencia"
$Button_DeshabilitarTransparencia.Location = New-Object System.Drawing.Point(500, 90)  # Ajusta la posición según sea necesario
$Button_DeshabilitarTransparencia.Size = New-Object System.Drawing.Size(250, 30)
$Button_DeshabilitarTransparencia.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")
$Button_DeshabilitarTransparencia.Font = New-Object System.Drawing.Font("Arial",9 )  # Establecer el tamaño de la letra

$Button_DeshabilitarTransparencia.Add_Click({
    # Deshabilitar la transparencia en la configuración de Windows de forma automática
    $registryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    $name = "EnableTransparency"
    $value = 0
    Set-ItemProperty -Path $registryPath -Name $name -Value $value
})

# Botón para apagar y entrar a la BIOS
$Button_ApagarBIOS = New-Object System.Windows.Forms.Button
$Button_ApagarBIOS.FlatStyle = 'Flat'
$Button_ApagarBIOS.Text = "Apagar y Entrar a BIOS"
$Button_ApagarBIOS.Location = New-Object System.Drawing.Point(500, 130)  # Ajusta la posición según sea necesario
$Button_ApagarBIOS.Size = New-Object System.Drawing.Size(250, 30)
$Button_ApagarBIOS.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")
$Button_ApagarBIOS.Font = New-Object System.Drawing.Font("Arial", 9)  # Establecer el tamaño de la letra

$Button_ApagarBIOS.Add_Click({
    # Apagar y entrar a la BIOS como administrador
    Start-Process -FilePath "shutdown" -ArgumentList "/r /fw /t 1" -Verb RunAs
})

# Botón para ingresar al entorno de recuperación
$Button_EntornoRecuperacion = New-Object System.Windows.Forms.Button
$Button_EntornoRecuperacion.FlatStyle = 'Flat'
$Button_EntornoRecuperacion.Text = "Ingresar al Entorno de Recuperacion"
$Button_EntornoRecuperacion.Location = New-Object System.Drawing.Point(500, 170)  # Ajusta la posición según sea necesario
$Button_EntornoRecuperacion.Size = New-Object System.Drawing.Size(250, 30)
$Button_EntornoRecuperacion.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")
$Button_EntornoRecuperacion.Font = New-Object System.Drawing.Font("Arial", 9)  # Establecer el tamaño de la letra

$Button_EntornoRecuperacion.Add_Click({
    # Ingresar al entorno de recuperación
    shutdown /r /o /f /t 00
})

$TabPage4.Controls.Add($Button_EntornoRecuperacion)

# Agregar el botón a la página
$TabPage4.Controls.Add($Button_DeshabilitarTransparencia)

$TabPage4.Controls.Add($Button_ApagarBIOS)
# Agregar el botón a la página
$TabPage4.Controls.Add($Button_AppearancePerformance)




#$TabControl.TabPages.Add($TabPage3)
$TabControl.TabPages.Add($TabPage4)

$Form.Controls.Add($TabControl)


$Form.ShowDialog()

Write-Host "Adios $rockEmoji" -ForegroundColor green
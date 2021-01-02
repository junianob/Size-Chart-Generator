$path = Get-Location
$id = -join ($path,"\id.txt")
$measurements =  -join ($path,"\measurements_chart.txt")
$size = -join ($path,"\size.txt")
$files = -join ($path,"\user_sizes_unprocessed")
$labels = -join ($path,"\labels.txt")
$location = -join ($path, "\user_sizes_unprocessed\")
$datastring = -join($path,"\user_data\")
$datapath = $datastring

$id = [IO.File]::ReadAllText($id)
$measurements = [IO.File]::ReadAllText($measurements)
$size = [IO.File]::ReadAllText($size)
$files = Get-ChildItem $files
$labels = [IO.File]::ReadAllText($labels)
Write-Host $path
$users = @()

foreach($f in $files)
{
$var = -join($location,$f);
$data = [IO.File]::ReadAllText($var)
$users += $data
}

$idarray = $id.Split([string[]]"`r`n", [StringSplitOptions]::None)
$measurementsarray = $measurements.Split([string[]]"`r`n", [StringSplitOptions]::None)
$sizearray = $size.Split([string[]]"`r`n", [StringSplitOptions]::None)
$userarray = $users.Split([string[]]"`r`n", [StringSplitOptions]::None)
$labelsarray = $labels.Split([string[]]"`r`n", [StringSplitOptions]::None)



$measurementslist = @((0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))
For ($i=0; $i -lt $measurementsarray.Length; $i++) {
    $measurementslist[$i] = $measurementsarray[$i].Split(",")
    }

$sizelist = @((0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))
For ($i=0; $i -lt $sizearray.Length; $i++) {
    $sizelist[$i] = $sizearray[$i].Split(",")
    }

$labelslist = @((0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0))
For ($i=0; $i -lt $labelsarray.Length; $i++) {
    $labelslist[$i] = $labelsarray[$i].Split(",")
    }


foreach($u in $userarray){
$filename = ""
$keystring = ""
$valuestring = ""
$uservars = $u.Split(",")
$filename += $uservars[0]
$filename += "_"
$filename += $uservars[1]
For ($a=0; $a -lt $labelsarray.Length; $a++) {
    $text = $labelslist[$a][1]
    $text += ":"
    $text += $uservars[$a]
    $keystring += $labelslist[$a][1] 
    $keystring += ","
    $valuestring += $uservars[$a]
    $valuestring += ","
	Write-Host $text
	$text = ""
}


	foreach($f in $idarray){
	$data = $f.split(",")
	$index = [int]$data[0]
	$text = $data[1]
	$keystring += $data[1]
	$keystring += ","
	$text += ":"
		$vars = $f.Split(",")
		$measurementsvars = $vars[2].Split(".");
		For ($j=0; $j -lt $measurementsvars.Length; $j++) {
			For ($k=1; $k -lt $measurementslist[$j].Length; $k++) {
				if($uservars[$j+$labelsarray.Length] -le $measurementslist[$j][$k]){

					$text += $sizelist[$index-1][$k]
					$valuestring += $sizelist[$index-1][$k]
					$valuestring += ","
					break
				}
			}

			if($uservars[$j+$labelsarray.Length] -gt $measurementslist[$j][$measurementslist[$j].Length-1]){
			    $text += $sizelist[$index-1][$measurementslist[$j].Length-1]
			    $valuestring += $sizelist[$index-1][$k]
			    $valuestring += ","
			}
		}
		Write-Host $text
		$text = ""
	}
	Write-Host $text

    $dataname = $filename
	$filename = -join($datastring,$filename)
	$filename = -join($filename, ".csv")

	if (!(Test-Path $filename))
	{
          Write-Host "File created in:"
	    Add-Content -Path $filename -Value $keystring
		Add-Content -Path $filename -Value $valuestring
	}
	else{
		Write-Host "ERROR: USER ALREADY EXISTS"
	}
	Write-Host $filename
	Write-Host $text
}
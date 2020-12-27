#Initializing workers and files
$workers = 3
$fList = (Get-ChildItem -Recurse -File).FullName
$files = (Get-ChildItem -Recurse -File | Measure-Object).Count
#Calculating result for Workers Sets
$result = $files / $workers
$remainder = $files % $workers
#Ending app if they is less files for the amount of workers
if($result -lt 1)
{
[System.Windows.MessageBox]::Show('Not enough files to complete the task')
exit
}
#Setting the number of files for each worker when their are equal amounts of files per worker
$set = New-Object int[] $workers
if($remainder -eq 0)
{
for($i=0;$i-lt$workers;$i++)
    {
        $set[$i] = $result
    }
}
else
{
    for($i=0;$i-lt$workers;$i++)
    {
        $set[$i] = $result
    }
    $set[$($workers-1)] += $remainder
}
#Moving Files to appropriate worker set
$curr = 0
for($i=0;$i-lt$workers;$i++)
    {
        $path = $('.\'+'Set'+($i+1))
        if($(Test-Path $path) -ne $true){New-Item -Path $path -ItemType Directory}
        for($j=0;$j-lt$set[$i];$j++)
            {
                if($fList[$curr] -ne $PSCommandPath)
                {
                    Move-Item $fList[$curr].Replace("[", "``[").replace("]", "``]") $path
                }
                $curr++
            }
    }
$workers
$files
$fList
$result
$remainder
$set
$set[0]
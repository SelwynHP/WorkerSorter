#Initializing workers and files
$workers = 3
$fList = (Get-ChildItem -File | Where-Object { $_.FullName -ne $PSCommandPath })
$files = $fList.Count
#Calculating result for Workers Sets
$result = $files / $workers
$remainder = $files % $workers
#Ending app if they is less files for the amount of workers
if($result -lt 1)
{
[System.Windows.MessageBox]::Show('Not enough files to complete the task')
exit
}
#Setting the number of files for each worker
$set = New-Object int[] $workers
for($i=0;$i-lt$workers;$i++)
    {
        $set[$i] = $result
    }
#Setting the number of files for each worker when their are not equal amounts of files per worker
if($remainder -ne 0)
{
    #Get decimal part of $result
    $decimal = $result - [math]::Truncate($result)
    #Depending on $decimal, we add remainder to last element of array($set) or calculate the last element
    if($decimal -gt 0.5)
    {
        $totals = 0
        for($i=0;$i-lt$set.Count-1;$i++)
        {
            $totals += $set[$i]
        }
        $set[$($workers-1)] = $files - $totals
    }
    else
    {
        $set[$($workers-1)] += $remainder
    }
}
#Moving Files to appropriate worker set
$curr = 0
for($i=0;$i-lt$workers;$i++)
    {
        $path = $('.\'+'Set'+($i+1))
        if($(Test-Path $path) -ne $true){New-Item -Path $path -ItemType Directory}
        for($j=0;$j-lt$set[$i];$j++)
            {
                Move-Item $fList[$curr].FullName.Replace("[", "``[").replace("]", "``]") $path
                $curr++
            }
    }

#for testing
#$workers
#$files
#$fList
#$result
#$remainder
#$set
#$set[0]
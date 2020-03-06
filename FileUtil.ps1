
class FileUtil {

    [string]$Path = $null
    [string[]]$content

    FileUtil(
        [string]$p
    ){
        $this.Path = $p
        $this.content = Get-Content -Path $p
    }

    [int]FindLine(
        [string]$match
    ){
        $retVal = -1
    
        for ($i=0; $i -lt $this.content.Count; $i++)
        {
            [string]$line = $this.content[$i];
            if ($line -like $match)
            {
                $retVal = $i
            }
            
        }

        return $retVal
    }

    [string]GetLine(
        [int]$lineNr
    ){
        return $this.content[$lineNr];
    }

    [string]ReplaceLine(
        [int]$lineNr,
        [string]$newLine
    ){
        $retVal = $this.content[$lineNr]
        $this.content[$lineNr] = $newLine
        return $retVal
    }

    Save(){
        Save($this.Path)
    }

    Save([string]$savePath){
        Set-Content -Path $savePath -Value $this.content
    }
    
}
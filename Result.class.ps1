#
# Some functions result.
#
class Result {
    [bool]$Ok = $false # Function succeeded.
    [string]$ErrorMessage = "" # Error message if failed ($OK is false).
    $Value # Value, undefined if failed.

    Result() {

    }

    Result(
        # Set to $this.Value if succeeded or to $this.ErrorMessage if failed.
        $Value, 

        # $true if succeeded, $false if failed.
        [bool]$Ok
    ) {
        $this.Ok = $Ok
        if (-not $Ok) {
            $this.ErrorMessage = $Value.ToString()
            $this.Value = $null
        }
        else {
            $this.ErrorMessage = ""
            $this.Value = $Value
        }    
    }

}

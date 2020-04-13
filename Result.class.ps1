#
# Some functions result.
#
class Result {
    [bool]$Ok # Function succeeded.
    [string]$ErrorMessage # Error message if failed ($OK is false).
    [string]$Value # Value, undefined if failed.

    Result(
        # Set to $this.Value if succeeded or to $this.ErrorMessage if failed.
        [string]$value, 

        # $true if succeeded, $false if failed.
        [bool]$ok
    ) {
        $this.Ok = $ok
        if (-not $ok) {
            $this.ErrorMessage = $value
            $this.Value = $null
        }
        else {
            $this.ErrorMessage = ""
            $this.Value = $value
        }    
    }

}

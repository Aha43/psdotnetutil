class Env {
    [string]$Name

    Env() {
        $this.Name = "allo"
    }

}

[Env]$e1 = [Env]::new()

$e1.Name
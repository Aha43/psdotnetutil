class DotProjectInfo {
    [string]$ProjectName = "" 
    [string]$QualifiedProjectName = "" 
    [string]$ProjectDir = ""  
    [string]$ProjectFile = "" 

    [string]$SolutionName = "" 
    [string]$SolutionDir = "" 
    [string]$SolutionFile = "" 

    [string]$RootDir = "" 

    [bool]$HasSolution 

    #
    # Creates name, file and directory information for a dotnet Project given a Project name and a sultion name for the Solution Project in.
    # The Solution / Project may not actually exists: This information may be used to create Project / Solution.
    #
    DotProjectInfo(
        # Solution name
        [string]$Solution,

        # Project name
        [string]$Project,

        # If true Project is not in the name space given by environment variable DevTopNameSpace
        [bool]$Nospace
    ) {
        $this.HasSolution = $true

        [string]$repoarea = $env:DevRepDir
        if (-not (Test-Path -Path $repoarea)) {
            Write-Error ("Repository area directory: " + $repoarea + " does not exists");
            return
        }

        $this.SolutionName = $Solution
        if ($env:DevTopNameSpace) {
            if (-not $Nospace) {
                $this.SolutionName = ($env:DevTopNameSpace + "." + $Solution)
            }
        }
    
        $this.SolutionDir = Join-Path -Path $repoarea -ChildPath $this.SolutionName
        $this.SolutionFile = Join-Path -Path $this.SolutionDir -ChildPath ($this.SolutionName + ".sln")
        $this.ProjectName = $Project
        $this.QualifiedProjectName = ($this.SolutionName + '.' + $Project)
        $this.ProjectDir = Join-Path -Path $this.SolutionDir -ChildPath $this.QualifiedProjectName
        $this.ProjectFile = Join-Path -Path $this.ProjectDir -ChildPath ($this.QualifiedProjectName + ".csproj")
        $this.RootDir = $this.SolutionDir
    }

    #
    # Creates name, file and directory information for a dotnet Project given a Project name.
    # The Solution / Project may not actually exists: This information may be used to create Project / Solution.
    #
    DotProjectInfo(
        # Project name
        [string]$Project,

        # If true Project is not in a Solution
        [bool]$Nosln,

        # If true Project is not in the name space given by environment variable DevTopNameSpace
        [bool]$Nospace,

        # If $false Solution name (this value only is used if $Nosln is $false) is same as qualified Project name.
        # If $true Solution name is stem to Project qualified name (if Project qualified name is a.b.c then Solution name is a.b).
        [bool]$Stemsln
    ) {
        [string]$repoarea = $env:DevRepDir
        if (-not $repoarea) {
            Write-Error "Repository area directory not given: set the DevRepDir env variable"
            return
        }

        $this.ProjectName = $Project
        $this.QualifiedProjectName = $Project
        $this.SolutionName = $Project

        if ($env:DevTopNameSpace) {
            if (-not $Nospace) {
                $this.QualifiedProjectName = ($env:DevTopNameSpace + "." + $Project)
                $this.SolutionName = $this.QualifiedProjectName
            }
        }
    
        if ($Nosln) {
            $this.ProjectDir = Join-Path -Path $repoarea -ChildPath $this.QualifiedProjectName
            $this.RootDir = $this.ProjectDir
            $this.SolutionName = ""
            $this.HasSolution = $false
        }
        else {
            $this.SolutionDir = Join-Path -Path $repoarea -ChildPath $this.QualifiedProjectName
            if ($Stemsln) {
                $pos = $this.QualifiedProjectName.LastIndexOf('.')
                $this.SolutionName = $this.QualifiedProjectName.Substring(0, $pos)
                $pos = $this.SolutionDir.LastIndexOf('.')
                $this.SolutionDir = $this.SolutionDir.Substring(0, $pos)
            }
            $this.ProjectDir = Join-Path -Path $this.SolutionDir -ChildPath $this.QualifiedProjectName
            $this.RootDir = $this.SolutionDir
            $this.SolutionFile = Join-Path -Path $this.SolutionDir -ChildPath ($this.SolutionName + ".sln")
            $this.HasSolution = $true
        }
        
        $this.ProjectFile = Join-Path -Path $this.ProjectDir -ChildPath ($this.QualifiedProjectName + ".csproj")
    }

}

function Get-Project-Info(
    [Parameter(Mandatory = $true)][string]$Project,
    [switch]$Nosln = $false,
    [switch]$Nospace = $false,
    [switch]$Stemsln = $false
) {
    [DotProjectInfo]$info = [DotProjectInfo]::new($Project, $Nosln, $Nospace, $Stemsln)

    return $info
}

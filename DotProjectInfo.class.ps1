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
    # Creates name, file and directory information for a dotnet project given a project name and a sultion name for the solution project in.
    # The solution / project may not actually exists: This information may be used to create project / solution.
    #
    DotProjectInfo(
        # Solution name
        [string]$solution,

        # Project name
        [string]$project,

        # If true project is not in the name space given by environment variable DevTopNameSpace
        [bool]$nospace
    ) {
        $this.HasSolution = $true

        [string]$repoarea = $env:DevRepDir
        if (-not (Test-Path -Path $repoarea)) {
            Write-Error ("Repository area directory: " + $repoarea + " does not exists");
            return
        }

        $this.SolutionName = $solution
        if ($env:DevTopNameSpace) {
            if (-not $nospace) {
                $this.SolutionName = ($env:DevTopNameSpace + "." + $solution)
            }
        }
    
        $this.SolutionDir = Join-Path -Path $repoarea -ChildPath $this.SolutionName
        $this.SolutionFile = Join-Path -Path $this.SolutionDir -ChildPath ($this.SolutionName + ".sln")
        $this.ProjectName = $project
        $this.QualifiedProjectName = ($this.SolutionName + '.' + $project)
        $this.ProjectDir = Join-Path -Path $this.SolutionDir -ChildPath $this.QualifiedProjectName
        $this.ProjectFile = Join-Path -Path $this.ProjectDir -ChildPath ($this.QualifiedProjectName + ".csproj")
        $this.RootDir = $this.SolutionDir
    }

    #
    # Creates name, file and directory information for a dotnet project given a project name.
    # The solution / project may not actually exists: This information may be used to create project / solution.
    #
    DotProjectInfo(
        # Project name
        [string]$project,

        # If true project is not in a solution
        [bool]$nosln,

        # If true project is not in the name space given by environment variable DevTopNameSpace
        [bool]$nospace,

        # If $false solution name (this value only is used if $nosln is $false) is same as qualified project name.
        # If $true solution name is stem to project qualified name (if project qualified name is a.b.c then solution name is a.b).
        [bool]$stemsln
    ) {
        [string]$repoarea = $env:DevRepDir
        if (-not $repoarea) {
            Write-Error "Repository area directory not given: set the DevRepDir env variable"
            return
        }

        $this.ProjectName = $project
        $this.QualifiedProjectName = $project
        $this.SolutionName = $project

        if ($env:DevTopNameSpace) {
            if (-not $nospace) {
                $this.QualifiedProjectName = ($env:DevTopNameSpace + "." + $project)
                $this.SolutionName = $this.QualifiedProjectName
            }
        }
    
        if ($nosln) {
            $this.ProjectDir = Join-Path -Path $repoarea -ChildPath $this.QualifiedProjectName
            $this.RootDir = $this.ProjectDir
            $this.SolutionName = ""
            $this.HasSolution = $false
        }
        else {
            $this.SolutionDir = Join-Path -Path $repoarea -ChildPath $this.QualifiedProjectName
            if ($stemsln) {
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
    [Parameter(Mandatory = $true)][string]$project,
    [switch]$nosln = $false,
    [switch]$nospace = $false,
    [switch]$stemsln = $false
) {
    [DotProjectInfo]$info = [DotProjectInfo]::new($project, $nosln, $nospace, $stemsln)

    return $info
}

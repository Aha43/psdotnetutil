# PowerShell functions of use when creating dotnet core projects

[To do list](https://github.com/Aha43/psdotnetutil/projects/1)

## Purpose

Functions (New-Dotnet-Project and Add-Dotnet-Project) to make it easier to follow the practice that dotnet core projects are named after their root namespace.

Uses two environment variables DevRepDir and DevRootNameSpace. First is mandatory and tell which directory repositories are in and second is optional and set root namespace. In the examples below DevRepDir is C:\repos and DevRootNameSpace is Org.Macroshaft

Making a new dot core project:

```
New-Dotnet -project Amazing.Api
```

Result is that in C:\repos a solution named Org.Macroshaft.Amazing.Api is created with a project also named Org.Macroshaft.Amazing.Api. The type of the project is by default webapi, use option -type <project-type> to make dotnet core project of specific type. If you need to create a project not in the default namespace (here Org.Macroshaft) use switch option -nospace. If you only want a report on what will be done but not actually create project use switch option -dryrun.

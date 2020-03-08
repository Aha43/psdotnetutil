# PowerShell functions of use when creating dotnet core projects

[Issues](https://github.com/Aha43/psdotnetutil/projects/1)

## Use

Functions (`New-Dotnet-Project` and `Add-Dotnet-Project`) aims to make it easier to follow the practice that dotnet core projects is to be named after their root namespace.

The functions uses two environment variables `DevRepDir` and `DevRootNameSpace`. First is mandatory and tell which directory repositories are in and second is optional and defines a namespace prefix. In the examples below `DevRepDir` is `C:\repos and DevRootNameSpace` is `Org.Macroshaft`.

### Making a new dot core project

```
New-Dotnet-Project -project Amazing.Api
```

Result is that in `C:\repos` a solution named `Org.Macroshaft.Amazing.Api` is created with a project also named `Org.Macroshaft.Amazing.Api`. The type of the project is by default `webapi`, use option `-type <project-type>` to make dotnet core project of a specific type. If you need to create a project not in the default namespace (here `Org.Macroshaft`) use switch option `-nospace`. The function also initialize a git repository with a default `.gitignore` file and do the first commit. If you only want a report on what will be done but not actually create project use switch option `-dryrun`.

### Adding a dot core project

```
Add-Dotnet-Project -solution Amazing.Api -project Services
```

Result is that a project named `Org.Macroshaft.Amazing.Api.Services` is created in the solution folder `Org.Macroshaft.Amazing.Api` and added to the solution. The type of the project created with this function is `classlib`, use option `-type <project-type>` to make dotnet core project of a specific type. If solution was created using `New-Dotnet-Project` with `-nospace` switch option you will need to use that option here to. The function will do a commit so you will want to be in a 'clean working tree' state before running this command. If you only want a report on what will be done but not actually create project use switch option `-dryrun`.

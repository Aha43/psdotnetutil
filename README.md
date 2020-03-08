# PowerShell functions of use when creating dotnet core projects

[To do list](https://github.com/Aha43/psdotnetutil/projects/1)

## Purpose

Functions (New-Dotnet-Project and Add-Dotnet-Project) to make it easier to follow the practice that dotnet core projects are named after their root namespace.

Uses two environment variables DevRep and DevRootNamespace. First is mandatory and tell which directory repositories are in and second is optional and set root namespace. I

Making a new dot core project:

```
New-Dotnet -project Amazing.Api
```

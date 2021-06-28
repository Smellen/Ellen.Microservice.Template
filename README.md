# Ellen.Microservice.Template
This is a template solution for any of my microservice work to give me a quick start.

Basic .NET 5.0 API with an example controller with one GET request endpoint.
An example xUnit test project with one example test. Using Moq and FluentValidation.

Swagger is also enabled. No authentication enabled.

### How to run
Clone the directory locally.
`git clone https://github.com/Smellen/Ellen.Microservice.Template.git`

Change directory.
`cd .\Ellen.Microservice.Template\src\Ellen.Microservice.Template\`

Run the application
`dotnet run`

### How to create a new microservice based on this template
The rename.ps1 script will create a new solution from the existing template. It will not alter the current solution but will create a new folder containing a full solution with the updated solution names.

Assuming the repo is cloned.
Change to the root directory.
`cd .\Ellen.Microservice.Template`

Run the following command in powershell: `./rename.ps1`

##### Other items to potentially rename 
- Swagger version is left as v1. If any other version is needed it will need to be updated in appsettings.json
- ExampleController will be copied over. Example unit test will also not be removed.

### To-Do list
- Add changelog.md template file.
- Add fluentvalidation nuget package.
- Add Serilog
- Fix the rename script error output
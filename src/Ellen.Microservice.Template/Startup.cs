using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.OpenApi.Models;

namespace Ellen.Microservice.Template
{
    public class Startup
    {
        private readonly string AppSettingsApiName = "ApiName";
        private readonly string AppSettingsApiVersion = "ApVersion";
        private readonly string AppSettingsSwaggerPathName = "SwaggerPathName";

        private readonly string ApiName;
        private readonly string ApiVersion;
        private readonly string SwaggerPathName;

        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
            ApiName = Configuration[AppSettingsApiName];
            ApiVersion = Configuration[AppSettingsApiVersion];
            SwaggerPathName = Configuration[AppSettingsSwaggerPathName];
        }

        public IConfiguration Configuration { get; }

        public void ConfigureServices(IServiceCollection services)
        {

            services.AddControllers();
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc(ApiVersion, new OpenApiInfo { Title = ApiName, Version = ApiVersion });
            });
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint(SwaggerPathName, $"{ApiName} {ApiVersion}"));
            }

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}

using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.OpenApi.Models;

namespace Ellen.Microservice.Template
{
    /// <summary>
    /// The startup class.
    /// </summary>
    public class Startup
    {
        private readonly string AppSettingsApiName = "ApiName";
        private readonly string AppSettingsApiVersion = "ApVersion";
        private readonly string AppSettingsSwaggerPathName = "SwaggerPathName";

        private readonly string ApiName;
        private readonly string ApiVersion;
        private readonly string SwaggerPathName;

        /// <summary>
        /// The startup constructor.
        /// </summary>
        /// <param name="configuration">The configuration.</param>
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
            ApiName = Configuration[AppSettingsApiName];
            ApiVersion = Configuration[AppSettingsApiVersion];
            SwaggerPathName = Configuration[AppSettingsSwaggerPathName];
        }

        /// <summary>
        /// The configuration.
        /// </summary>
        public IConfiguration Configuration { get; }

        /// <summary>
        /// Configure the services.
        /// </summary>
        /// <param name="services">The service collection.</param>
        public void ConfigureServices(IServiceCollection services)
        {

            services.AddControllers();
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc(ApiVersion, new OpenApiInfo { Title = ApiName, Version = ApiVersion });
            });
        }

        /// <summary>
        /// Configuring the application.
        /// </summary>
        /// <param name="app">The application builder.</param>
        /// <param name="env">The web host environment.</param>
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

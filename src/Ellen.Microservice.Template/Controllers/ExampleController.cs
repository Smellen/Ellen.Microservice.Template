using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace Ellen.Microservice.Template.Controllers
{
    /// <summary>
    /// The example controller.
    /// </summary>
    /// <seealso cref="Microsoft.AspNetCore.Mvc.ControllerBase" />
    [ApiController]
    [Route("api/[controller]")]
    public class ExampleController : ControllerBase
    {
        private static readonly string[] ExampleStrings = new[] { "hello", "world" };
        private readonly ILogger<ExampleController> _logger;

        /// <summary>
        /// Initializes a new instance of the <see cref="ExampleController"/> class.
        /// </summary>
        /// <param name="logger">The logger.</param>
        /// <exception cref="System.ArgumentNullException">logger</exception>
        public ExampleController(ILogger<ExampleController> logger)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        /// <summary>
        /// Gets an example string array.
        /// </summary>
        /// <returns>An array of strings.</returns>
        [HttpGet]
        public IEnumerable<string> Get()
        {
            _logger.LogInformation("This is an example log.");
            return ExampleStrings;
        }
    }
}

using Ellen.Microservice.Template.Controllers;
using FluentAssertions;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace Ellen.Microservice.Template.UnitTests
{
    public class ExampleUnitTests
    {
        private readonly ExampleController _controller;

        public ExampleUnitTests()
        {
            var mockLogger = new Mock<ILogger<ExampleController>>();
            _controller = new ExampleController(mockLogger.Object);
        }

        [Fact]
        public void ExampleController_Get_ReturnsSuccessfully()
        {
            // Arrange

            // Act
            var result = _controller.Get();

            // Assert
            result.Should().NotBeNullOrEmpty();
            result.Should().HaveCount(2);
            result.Should().Contain("hello");
            result.Should().Contain("hello");
        }
    }
}

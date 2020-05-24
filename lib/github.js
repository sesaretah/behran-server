var page = require('webpage').create();
var system = require('system');
page.viewportSize = { width: 800, height: 600 };

function renderCurrentViewport(page, filename) {
    var viewportSize = page.viewportSize;
    var scrollOffsets = page.evaluate(function() {
      return {
        x: window.pageXOffset,
        y: window.pageYOffset
      };
    });
    page.clipRect = {
      top: scrollOffsets.y,
      left: scrollOffsets.x,
      height: viewportSize.height,
      width: viewportSize.width
    };
    page.render(filename);
  }
  
  page.open(system.args[1], function(status) {
    renderCurrentViewport(this, system.args[2]);
    phantom.exit();
  });
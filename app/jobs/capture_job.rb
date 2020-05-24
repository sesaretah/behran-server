class CaptureJob < ApplicationJob
  queue_as :default

  def perform(url, id)
    Dir.chdir(Rails.root.join('public', 'images'))
    system "phantomjs #{PATH_TO_PHANTOM_SCRIPT} #{url} #{self.id}.png"
  end
end

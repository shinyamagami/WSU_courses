require_relative 'lib/WSU_courses/version'

Gem::Specification.new do |spec|
  spec.name          = "WSU_courses"
  spec.version       = "0.1.4"
  spec.authors       = ["Shin Yamagami"]
  spec.email         = ["kiboh.usa@gmail.com"]

  spec.summary       = "Find all the classes in the past at WSU"
  spec.description   = "Find all the classes in the past at WSU"
  spec.homepage      = "https://github.com/shinyamagami/WSU_In_Person"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6")

#  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
#  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end

#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint gt4_flutter_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'gt4_flutter_plugin'
  s.version          = '0.0.2'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'https://www.geetest.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Geetest' => 'xuwei@geetest.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Download SDKs from office website manually and import it to `./Libraries/`
  s.subspec 'Vendor' do |sp|
    sp.resources = "Libraries/*.bundle"
    sp.vendored_frameworks = 'Libraries/*.framework'
    sp.frameworks = 'WebKit'
  end

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 i386' }
  s.swift_version = '5.0'
end

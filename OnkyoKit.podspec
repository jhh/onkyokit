Pod::Spec.new do |s|
  s.name     = 'OnkyoKit'
  s.version  = '0.5.0'
  s.license  = 'MIT'
  s.summary  = 'A Onkyo eISCP framework for Objective-C.'
  s.homepage = 'https://github.com/jhh/onkyokit'
  # s.social_media_url = 'https://twitter.com/AFNetworking'
  s.authors  = { 'Jeff Hutchison' => 'jeff@jeffhutchison.com' }
  s.source   = { :git => 'https://github.com/jhh/onkyokit.git', :tag => "0.5.0", :submodules => true }
  s.requires_arc = true

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.public_header_files = 'OnkyoKit/*.h'
  s.source_files = 'OnkyoKit/*.{h,m}'
  s.resource_bundles = {
    'OnkyoKit' => 'OnkyoKit/Assets/TX-NR616.plist'
  }

end

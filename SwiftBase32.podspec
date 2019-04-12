Pod::Spec.new do |s|
  s.name                      = 'SwiftBase32'
  s.version                   = '0.7.0'
  s.summary                   = 'Base32 implementation for Swift.'
  s.homepage                  = 'https://github.com/norio-nomura/Base32'
  s.source                    = { :git => s.homepage + '.git', :tag => s.version }
  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Norio Nomura' => 'norio.nomura@gmail.com' }
  s.source_files              = 'Sources/**/*.{h,c,swift}'
  s.pod_target_xcconfig       = { 'APPLICATION_EXTENSION_API_ONLY' => 'YES' }
  s.ios.deployment_target     = '8.0'
  s.osx.deployment_target     = '10.9'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'
end

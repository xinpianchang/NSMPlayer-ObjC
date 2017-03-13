Pod::Spec.new do |s|
  s.name             = 'NSMPlayer'
  s.version          = '0.1.2'
  s.summary          = 'NSMPlayer is a library of playing video.'

  s.homepage         = 'https://git.vmovier.cc/projects/NSM/repos/nsmplayer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Lin Lin' => 'linlin@vmovier.com' }
  s.source           = { :git => 'https://git.vmovier.cc/scm/nsm/nsmplayer.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'NSMPlayer/Classes/**/*'

  s.dependency 'Bolts'

  s.dependency 'NSMStateMachine'

  s.dependency 'Masonry'

  s.dependency 'Reachability'
end

class hosts::ertp-preview {
  host { 'ertp-api':    ip => '10.239.86.141' }
  host { 'ertp-mongo-1':  ip => '10.236.89.222' }
  host { 'ertp-mongo-2':  ip => '10.32.0.78' }
  host { 'ertp-mongo-3':  ip => '10.228.170.128' }
  host { 'places-api':  ip => '10.229.118.175' }
}

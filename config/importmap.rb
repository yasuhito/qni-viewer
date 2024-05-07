# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@rails/actioncable', to: 'actioncable.esm.js'
pin_all_from 'app/javascript/channels', under: 'channels'
pin '@qni/common', to: '@qni--common.js' # @0.0.86
pin 'ansi-styles' # @5.2.0
pin 'fraction.js' # @4.2.1
pin 'pretty-format' # @29.7.0
pin 'react-is' # @18.3.1

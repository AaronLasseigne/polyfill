# frozen_string_literal: true

require 'polyfill'

using Polyfill(String: %w[#+@])

print((+ 'frozen string').frozen? ? 'immutable' : 'mutable')

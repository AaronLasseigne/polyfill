# frozen_string_literal: true

require 'polyfill'

using Polyfill(String: %w[#+@], version: '2.3')

print((+ 'frozen string').frozen? ? 'immutable' : 'mutable')

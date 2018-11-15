package = "kong-jwt-claim-headers"
version = "1.0-1"
source = {
  url = "https://github.com/scmp/kong-jwt-claim-headers/archive/v1.0.1.tar.gz",
  file = "v1.0.1.tar.gz",
  dir = "kong-jwt-claim-headers-1.0.1",
  tag = "v1.0.1"
}
description = {
  summary = "A Kong plugin to map JWT claims to request headers ",
  license = "MIT",
  homepage = "https://geeks.wego.com"
}
dependencies = {
  "lua ~> 5.1",
  "kong >= 0.10",
  "jsonpath >= 1.0"
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.jwt-claim-headers.handler"] = "handler.lua",
    ["kong.plugins.jwt-claim-headers.schema"]  = "schema.lua",
    ["kong.plugins.jwt-claim-headers.claim_headers"]  = "claim_headers.lua"
  }
}

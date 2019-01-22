local BasePlugin = require "kong.plugins.base_plugin"
local responses = require "kong.tools.responses"
local jwt_decoder = require "kong.plugins.jwt.jwt_parser"
local jp = require "jsonpath"
local JWT_PLUGIN_PRIORITY = (require "kong.plugins.jwt.handler").PRIORITY
local CLAIM_HEADERS = require "kong.plugins.jwt-claim-headers.claim_headers"

local ngx_set_header = ngx.req.set_header
local ngx_re_gmatch = ngx.re.gmatch

local JwtClaimHeadersHandler = BasePlugin:extend()

-- Set this plugin to execute after the default jwt plugin provided by Kong
-- Plugins with higher priority are executed first
JwtClaimHeadersHandler.PRIORITY = JWT_PLUGIN_PRIORITY - 100

local function retrieve_token(request, conf)
  local uri_parameters = request.get_uri_args()

  for _, v in ipairs(conf.uri_param_names) do
    if uri_parameters[v] then
      return uri_parameters[v]
    end
  end

  local authorization_header = request.get_headers()["authorization"]
  if authorization_header then
    local iterator, iter_err = ngx_re_gmatch(authorization_header, "\\s*[Bb]earer\\s+(.+)")
    if not iterator then
      return nil, iter_err
    end

    local m, err = iterator()
    if err then
      return nil, err
    end

    if m and #m > 0 then
      return m[1]
    end
  end
end

function JwtClaimHeadersHandler:new()
  JwtClaimHeadersHandler.super.new(self, "jwt-claim-headers")
end

function JwtClaimHeadersHandler:access(conf)
  JwtClaimHeadersHandler.super.access(self)

  local token, _ = retrieve_token(ngx.req, conf)
  -- Do nothing if no token
  if token ~= nil then
    local jwt, _ = jwt_decoder:new(token)
    local claims = jwt.claims

    for json_path, request_header in pairs(CLAIM_HEADERS) do
      local claim_value = jp.value(claims, json_path)
      if claim_value ~= nil then
        ngx_set_header(request_header, claim_value)
      end
    end
  end
end

return JwtClaimHeadersHandler

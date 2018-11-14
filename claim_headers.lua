-- Maps claim keys to request headers
return {
  ["$.drupal.uid"] = "X-Consumer-Token-User-Id",
  ["$.sub"] = "X-Consumer-Token-User-Uuid",
  ["$.iss"] = "X-Consumer-Token-Issuer",
  ["$.drupal.roles"] = "X-Consumer-Token-User-Roles",
  ["$.drupal.email"] = "X-Consumer-Token-User-Email"
}

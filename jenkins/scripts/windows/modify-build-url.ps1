# USED FOR MODIFYING BUILD_URL SENT TO BUILDPULSE FOR BETTER GROUPING
param (
    [string]$BUILD_URL
)

# If url ends with "/" we have to correct splitting
$CORRECTION = 0
if ($BUILD_URL -Match '/$') {
    $CORRECTION = 1
}

# We need to remove configuration part from url
$URL_PARTS = $BUILD_URL -Split '/'
$URL_PARTS = $URL_PARTS[0..($URL_PARTS.Length - (3 + $CORRECTION))] + $URL_PARTS[-(1 + $CORRECTION)]
$BUILD_URL = $URL_PARTS -Join '/'

Write-Output $BUILD_URL

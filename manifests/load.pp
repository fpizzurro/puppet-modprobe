define modprobe::load (
  $modulename = '',
  $default    = true,
) {

  $module = $modulename? {
    ''      => $name,
    default => $modulename,
  }

  exec {"modprobe $module":
    command => "/sbin/modprobe $module",
    unless  => "/sbin/lsmod | grep $module",
  }

  if $default {
    augeas { "modprobe $module default":
      context => "/files/etc/modules",
      changes => [
        "ins $module after *[last()]",
      ],
    }
  }

}

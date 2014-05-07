{% set ruby_version = "2.0.0-p247" %}
{% set ruby_url = "http://xyz.lcs.mit.edu/ruby/ruby-" +
 ruby_version + ".tar.gz" %}

system-ruby-absent:
  pkg.removed:
    - name: ruby1.8
  cmd.wait:
    - name: apt-get purge 'ruby*'
    - watch:
      - pkg: system-ruby-absent

ruby-deps:
  pkg.installed:
    - pkgs:
      - build-essential
      - openssl
      - libreadline6
      - libreadline6-dev
      - libyaml-dev
      - curl
      - git
      - sed
      - coreutils
      - gawk
      - gzip
      - bzip2
      - zlib1g
      - zlib1g-dev
      - libssl-dev
      - libyaml-dev
      - libsqlite3-0
      - libsqlite3-dev
      - sqlite3
      - libxml2-dev
      - libxslt1-dev
      - autoconf
      - libc6-dev
      - libncurses5-dev
      - automake
      - libtool
      - bison
      - subversion

{% set build_dir = "/tmp/ruby" %}

ruby:
  cmd.run:
    - name: >-
        rm -rf {{build_dir}} && mkdir -p {{build_dir}} && cd {{build_dir}} &&
        curl {{ruby_url}} | tar xz &&
        cd ruby-{{ruby_version}} && ./configure && make install;
    - unless: >-
        which ruby &&
        ruby --version | grep $(echo "{{ruby_version}}" | tr -d '-')
    - require:
      - pkg: ruby-deps
      - cmd: system-ruby-absent

ruby-bundler:
  gem.installed:
    - name: bundler
    - require:
      - cmd: ruby
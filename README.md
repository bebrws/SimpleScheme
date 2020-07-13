# What is this?
An iOS application to allow users to write scheme on the go that doesn't cost any money and is interpreted on the phone.

I am using a project:
https://github.com/kenpratt/rusty_scheme/

Which I cross compiled for arm64 and statically linked.
I added some code in my forks ios branch for creating the entry point to the interpreter so that after linking in the static library I could actually make a call to interpret whatever code the user provides.

I included the rusty_scheme license in this repo as well.

This was meant to be a weekend project so I haven't put a ton of time into it. But I would like to follow better design practices if I get more time or drive to work on this project.

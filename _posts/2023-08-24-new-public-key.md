---
layout: post
title:  "Changing my public key"
---

I use a [Nitrokey](https://www.nitrokey.com/) to generate and store my private key. This is the most secure way, because it never leaves the device and no other copy exists. The Nitrokey protects the use of the key by a rate-limited PIN code. The only way it could get compromised is someone taking the Nitrokey and [beating the PIN out of me](https://xkcd.com/538/).

I use my private key to sign the boot files on my computer. Yesterday evening -- when re-flashing my [Heads](https://osresearch.net/) install -- I answered some of the prompts a bit to quickly without fully comprehending my actions. As a result I went through a factory reset procedure that wiped my private key.

Now I no longer have access to it and needed to generate [a new one](https://keys.openpgp.org/vks/v1/by-fingerprint/0C276715E93D4CE54007BDBF54EB584E8668B05F). This new key is signed by an [older key](https://keys.openpgp.org/vks/v1/by-fingerprint/D7CAF2DB658D89BC08D6A7AADA6E167B8F541FB6) which is known to several of my contacts, in addition to my [Qubes Documentation Signing Key](https://github.com/QubesOS/qubes-secpack/blob/main/keys/doc-signing/sven-qubes-doc-signing-keys.asc) which in turn was previously signed by [the lost key](https://keys.openpgp.org/vks/v1/by-fingerprint/DA5975C9ABC40C833B2F620B2A632C537D744BC7).

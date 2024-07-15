; CRC16_CCIT_ZERO impl
; INPUT: r10 = starting address in SRAM bank $70
; INPUT: r12 = size of data in bytes (default loop counter)
; OUTPUT: r0 = checksum
generic_checksum:
    cache
    ibt r0,#$00 ; initial checksum value is zero
    iwt r3,#$1021 ; r3 = CRC polynomial
    iwt r13,#.loop ; r13 = loop start address
.loop {
        to r1 : ldb (r10) ; fetch the latest byte

        ; r0 ^= (r1 << 8)
        with r1 : swap ; effectively bitshift left 8
        xor r1

        ibt r1,#$07 ; loop over 8 bits
      - {
            ; r0 = r0 << 1
            rol : bic #1 ; superfx doesn't have a bitshift left instruction, so we need to mask bit 0

            bcc + : nop ; check if bit 15 was set before the shift
            {
                xor r3 ; r0 ^= polynomial
          + }
            dec r1
            bpl - : nop
        }
        loop
    }
    inc r10 ; the instruction following a branch instruction is always executed, so do the increment here
    stop
    nop

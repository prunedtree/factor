! Copyright (C) 2008, 2009 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: namespaces assocs kernel accessors
sorting sets sequences arrays
cpu.architecture
sequences.deep
compiler.cfg
compiler.cfg.rpo
compiler.cfg.instructions
compiler.cfg.value-numbering.graph
compiler.cfg.value-numbering.expressions
compiler.cfg.value-numbering.simplify
compiler.cfg.value-numbering.rewrite ;
IN: compiler.cfg.value-numbering

! Local value numbering.

: >copy ( insn -- insn/##copy )
    dup dst>> dup vreg>vn vn>vreg
    2dup eq? [ 2drop ] [ any-rep \ ##copy new-insn nip ] if ;

: rewrite-loop ( insn -- insn' )
    dup rewrite [ rewrite-loop ] [ ] ?if ;

GENERIC: process-instruction ( insn -- insn' )

M: ##flushable process-instruction
    dup rewrite
    [ process-instruction ]
    [ dup number-values >copy ] ?if ;

M: insn process-instruction
    dup rewrite
    [ process-instruction ] [ ] ?if ;

M: array process-instruction
    [ process-instruction ] map ;

: value-numbering-step ( insns -- insns' )
    init-value-graph
    init-expressions
    [ process-instruction ] map flatten ;

: value-numbering ( cfg -- cfg' )
    [ value-numbering-step ] local-optimization

    cfg-changed predecessors-changed ;

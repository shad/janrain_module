#!/bin/bash
if [[ ! -d "gh_docs" ]]; then 
  mkdir gh_docs
fi
(cd Docs/Doxygen/JRCapture && doxygen GHPagesDoxyfile)
(cd Docs/Doxygen/JREngage && doxygen GHPagesDoxyfile)


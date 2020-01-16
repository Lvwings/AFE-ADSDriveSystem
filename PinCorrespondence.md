# PinCorrespondence
this file indicates the pin correspondence between FPGA and board.
| Interface pin number | board pin name | FPGA signal name | FPGA port | Interface pin number | board pin name | FPGA signal name | FPGA port |
| :-- | :-- | :-- | :-- | :-- | :-- | :-- | :-- |
|  1   |   ADC_SDOA  |   ADS_SDOA  |  C26   |  16   |  STO   |   AFE_STO  |   U25  |
|  2   |   ADC_BUSY  |  ADS_BUSY   |   D26  |  17   |   ADC_SDOB  |  ADS_SDOB   | V23    |
|  3   |   ADC_CS  |  ADS_CS_N   |   G25  |   18  | ADC_CLOCK    |  ADS_CLK   |  W24   |
|  4   |  ADC_RD   |  ADS_RD   |   G26  |  19   |   ADC_CONVST  |   ADS_CONVST  | AA24    |
|  5   |   ADC_SDI  |   ADS_SDI |  H24   |  20   |  ADC_M0   |  ADS_M[0]    |   AA25  |
|  6   |  ADC_M1   |   ADS_M[1]  |  K26   |  21   |  STI   |  AFE_STI   |   AA23  |
|  7   |  SMT-MD   |  AFE_SMT_MD   |  K24   |  22   |  PGA-1   |  AFE_PGA[1]    |  AE24   |
|  8   |   PGA-0  |  AFE_PGA[0]   |  L24   |  23   |  INTUPZ   |  AFE_INPUTZ   |    AF25 |
|  9   |  PGA-2   |   AFE_PGA[2]  |  N23   |  24   |  NAPZ   |   AFE_NAPZ  |  D24   |
|  10   |  ENTRI   | AFE_ENTRI    |  M24   |  25   |   CLK  |  AFE_CLK   |    E25 |
|  11   |   PDZ  |  AFE_PDZ   |   N25  |  26   |  SHS   |  AFE_SHS   |  J25  |
|  12   |   DF-SM  |  AFE_SMT_MD   |   R25  |  27   |  INTG   |  AFE_INTG   |   H26  |
|  13   |  SHR   |  AFE_SHR   |    P24  |    |     |     |     |
|  14   |   IRST  |  AFE_IRST   |  T24   |     |     |     |     |
|  15   |   EOC  |  AFE_EOC   |   U23  |     |     |     |     |
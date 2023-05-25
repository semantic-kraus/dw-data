xquery version "3.1";

declare namespace tei = "http://www.tei-c.org/ns/1.0";

let $items := doc("/db/dw/xml/quote_permalinks_2023_04.xml")//item

return 
    <result>
         {
            for $item in subsequence($items, 1, 2100)
                return 
                    <item>
                        {$item/*}
                        {
                            let $source := translate($item/source, '#', '')
                            let $bibl := doc("/db/dw/xml/listbibl.xml")//tei:bibl[tei:citedRange[@xml:id=$source]]
                            
                            let $wholeText :=   if (exists($bibl/tei:citedRange[@xml:id=$source and @wholeText='yes'])) then
                                                    "yes"
                                                else
                                                    "no"
                            let $wholePeriodical :=   if (exists($bibl/tei:citedRange[@xml:id=$source and @wholePeriodical='yes'])) then
                                                    "yes"
                                                else
                                                    "no"
                                                    
                            let $hasRefInt :=   if (exists($bibl/tei:citedRange[@xml:id=$source and ref[type='int']])) then
                                                    "yes"
                                                else
                                                    "no"
                            let $posCitedRange :=  count( $bibl/tei:citedRange[@xml:id=$source]/preceding-sibling::tei:citedRange) +1
                                
                            return 
                                    <info source="{$source}" wholeText="{$wholeText}" wholePeriodical="{$wholePeriodical}" hasRefInt="{$hasRefInt}" posCitedRange="{$posCitedRange}"/>

                        }
                    </item>
         }
    </result>
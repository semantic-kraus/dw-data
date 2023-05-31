xquery version "3.1";

declare namespace tei = "http://www.tei-c.org/ns/1.0";

let $items := doc("/db/dw/xml/quote_permalinks_2023_04.xml")//item

return 
    <result>
         {
            for $item in subsequence($items, 1, 2200)
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
                                                    
                            let $hasRefInt :=   if (exists($bibl/tei:citedRange[@xml:id=$source and tei:ref[@type='int']])) then
                                                    substring($bibl/tei:citedRange[@xml:id=$source]/tei:ref[@type='int']/@target, 2) 
                                                    (: "yes":)
                                                else
                                                    "no"
                                                    
                            let $refIntSubtype :=   if (exists($bibl/tei:citedRange[@xml:id=$source and tei:ref[@type='int']])) then
                                                        $bibl/tei:citedRange[@xml:id=$source]/tei:ref[@type='int']/@subtype
                                                    else
                                                        "no" 
                            let $refLevel :=    if ($hasRefInt = 'no') then
                                                    "none"
                                                else (
                                                    let $citedRange := doc("/db/dw/xml/listbibl.xml")//tei:bibl/tei:citedRange[@xml:id=$hasRefInt]
                                                    return if ($citedRange[@wholeText="yes"]) then
                                                                "text"
                                                            else if ($citedRange[@wholePeriodical="yes"]) then
                                                                "periodical"
                                                            else
                                                                "none"
                                                )
                                                    
                            let $posCitedRange :=  count($bibl/tei:citedRange[@xml:id=$source]/preceding-sibling::tei:citedRange)
                                
                            return 
                                    <info source="{$source}" wholeText="{$wholeText}" wholePeriodical="{$wholePeriodical}" refInt="{$hasRefInt}" refIntSubtype="{$refIntSubtype}" refLevel="{$refLevel}" posCitedRange="{$posCitedRange}"/>

                        }
                    </item>
         }
    </result>
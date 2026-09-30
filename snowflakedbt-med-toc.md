# Snowflake/dbt-kursen — Studieanteckningar

## Innehållsförteckning

1. [Introduktion till datalager (Data Warehousing)](#lektion-0001-introduktion-till-datalager-data-warehousing)
2. [Verktygsstacken och utvecklingsmiljön](#lektion-verktygsstacken-och-utvecklingsmiljön)
3. [Koppla Snowflake till Visual Studio Code](#lektion-koppla-snowflake-till-visual-studio-code)
4. [Snowsight (Snowflakes webbgränssnitt)](#lektion-snowsight-snowflakes-webbgränssnitt)
5. [Snowflakes arkitektur och teori](#lektion-snowflakes-arkitektur-och-teori)
6. [Virtuella lager i Snowflake (kodning)](#lektion-virtuella-lager-i-snowflake-kodning)
7. [Roller och säkerhet i Snowflake](#lektion-roller-och-säkerhet-i-snowflake)
8. [RBAC i Snowflake (praktisk kodning)](#lektion-rbac-i-snowflake-praktisk-kodning)
9. [Data Load Tool (DLT) och extrahering/laddning (teori)](#lektion-data-load-tool-dlt-och-extraheringladdning-teori)
10. [Extrahera och ladda CSV-data till Snowflake med DLT (praktisk kodning)](#lektion-extrahera-och-ladda-csv-data-till-snowflake-med-dlt-praktisk-kodning)
11. [Extrahera data från API med DLT (teori)](#lektion-extrahera-data-från-api-med-dlt-teori)
12. [Extrahera och ladda API-data till Snowflake med DLT (praktisk kodning)](#lektion-extrahera-och-ladda-api-data-till-snowflake-med-dlt-praktisk-kodning)
13. [Dimensionell modellering och stjärnscheman (teori)](#lektion-dimensionell-modellering-och-stjärnscheman-teori)
14. [Datamarknader (Data Marts) och servering av data](#lektion-datamarknader-data-marts-och-servering-av-data)
15. [dbt (data build tool) — teoretiska grunder](#lektion-dbt-data-build-tool--teoretiska-grunder)
16. [dbt-modellering i praktiken med Snowflake](#lektion-dbt-modellering-i-praktiken-med-snowflake)
17. [Datatester i dbt](#lektion-datatester-i-dbt)
18. [Streamlit-dashboard för jobbannonser (praktisk kodning)](#lektion-streamlit-dashboard-för-jobbannonser-praktisk-kodning)

---


## Lektion 00/01: Introduktion till datalager (Data Warehousing)

### Spridda datakällor (Disparate Data Sources)

Data om en och samma verksamhet lagras ofta på många olika platser och i olika format — till exempel i kassasystem, lagersystem, sociala medier, väder-API:er och lokala Excel-filer. Detta uppstår eftersom olika affärsområden bygger egna system utifrån sina omedelbara, kortsiktiga behov, utan någon central samordning.

Problemet med detta är att om data ligger spridd på enskilda personers datorer, till exempel i olika Excel-ark, finns ingen gemensam "source of truth". Det leder till inkonsekventa beslut i verksamheten och att intressenter så småningom tappar förtroendet för datan, eftersom olika personer kan komma fram till olika svar beroende på vilken källa de utgått från.

### OLTP vs. OLAP (Transaktionella vs. analytiska databaser)

**OLTP (Online Transaction Processing)** är operativa databaser (t.ex. PostgreSQL, MySQL) som är optimerade för snabba, frekventa inskrivningar och uppdateringar av enskilda transaktioner i realtid. De sparar sällan djup historik, eftersom deras syfte är att stötta den löpande driften.

**OLAP (Online Analytical Processing)** är datalager optimerade för komplexa analysfrågor över stora mängder historisk data. Syftet är det motsatta mot OLTP: inte snabba enskilda transaktioner, utan att kunna slå samman och analysera stora datamängder över tid.

Anledningen till att man separerar dessa två är prestanda: om man körde tunga analytiska rapporter direkt mot samma databas som hanterar den löpande driften skulle det sänka prestandan i källsystemen och riskera att störa den operativa verksamheten. Genom att flytta analysen till en separat OLAP-miljö (datalagret) undviker man den konflikten.

### Datalagrets roll i en modern data stack

Ett datalager är ett centralt, ofta molnbaserat, repositorium som samlar in historisk och aktuell data från alla uppströmssystem (upstream) för att sedan servera nedströmssystem (downstream) — som dashboards, rapporter och maskininlärningsmodeller.

Fördelen med denna arkitektur är att den separerar beräkning (compute) från lagring (storage). Det gör det möjligt att skala de två oberoende av varandra: man kan öka beräkningskraften för en tung analys utan att behöva flytta eller duplicera själva lagringen. Det ger också en enklare och mer kontrollerad struktur, där data transformeras på ett styrt sätt istället för att varje system gör sina egna, oberoende transformationer.

### Datalagrets livscykel och beståndsdelar

Att bygga och driva ett datalager är en iterativ process, inte ett engångsprojekt, och den kan delas in i följande beståndsdelar:

1. **Affärskrav och datamodellering** — samarbete med verksamheten för att bestämma hur data ska struktureras, till exempel via ett stjärnschema.
2. **ETL/ELT-utveckling** — extrahering, inläsning (load) och transformation av data från källsystemen.
3. **Testning** — säkerställer att buggar eller felaktig indata inte förstör förtroendet för rapporterna som verksamheten förlitar sig på.
4. **Deployment och underhåll** — orkestrering av schemalagda körningar samt löpande anpassning när affärsbehoven förändras.

Anledningen till att man behöver en strukturerad livscykel, snarare än att bara bygga lösryckta lösningar, är att datamiljön annars blir svårhanterlig över tid och inte klarar av att följa med när affärsbehoven förändras.

### Tekniska termer

- **OLTP (Online Transaction Processing)** — databasarkitektur optimerad för snabba och frekventa operativa transaktioner.
- **OLAP (Online Analytical Processing)** — arkitektur optimerad för aggregering, analys och stora historiska datamängder.
- **Upstream / Downstream** — beskriver flödesriktningen för data: uppströms (upstream) är källsystemen som producerar data, nedströms (downstream) är konsumenterna, t.ex. BI-verktyg och rapporter.
- **Stjärnschema (Star Schema)** — en datamodelleringsmetod (från Kimball-metoden) med en central faktatabell omgiven av dimensionstabeller; vanligt förekommande i datalager.
- **Granularitet (Grain)** — nivån av detaljrikedom i datan. Lägre (mer atomär) granularitet ger större flexibilitet för framtida analysbehov.

### Kontrollfrågor

1. Varför är det problematiskt ur ett datakvalitetsperspektiv att låta anställda spara och bearbeta affärskritiska data i egna, lokala Excel-filer istället för i en centraliserad miljö?
2. Hur skiljer sig syftet och prestandakraven mellan en OLTP-databas och en OLAP-databas (datalager)?
3. Vad innebär det att separera beräkning (compute) och lagring i en modern datalagerarkitektur?
4. Varför är det kritiskt att arbeta med datatestning innan rapporterna når slutna intressenter i verksamheten?

## Lektion: Verktygsstacken och utvecklingsmiljön

### Den moderna verktygsstacken för Data Engineering

Den moderna verktygsstacken för data engineering består av en uppsättning specialiserade, ofta molnbaserade och Python-baserade verktyg som tillsammans hanterar hela livscykeln från datakälla till slutlig rapport. Istället för att bygga egna, sköra skript för varje steg använder man branschstandarder som är modulära, lätta att skala och har inbyggt stöd för testning och versionshantering.

Genom att separera verktygen efter funktion — till exempel DLT för inläsning, Snowflake för lagring och DBT för transformation — kan varje del optimeras separat, vilket underlättar felsökning och vidareutveckling jämfört med en enda monolitisk process.

### Versionshantering och utvecklingsmiljö

Kursens arbetssätt kombinerar Git/GitHub för versionshantering, Visual Studio Code som IDE, terminalen (Bash/Git Bash) samt virtuella miljöer hanterade via UV. Detta säkerställer spårbarhet i koden, möjliggör samarbete och undviker beroendekonflikter mellan olika Python-paket.

### Tekniska termer

- **DLT (Data Load Tool)** — ett Python-baserat open source-verktyg för att extrahera och ladda data från olika källor till ett datalager.
- **Snowflake** — ett molnbaserat datalager (data warehouse) som separerar lagring och beräkning.
- **DBT (Data Build Tool)** — ett verktyg för att transformera data direkt i datalagret med hjälp av SQL och moduler, samt hantera dokumentation och tester.
- **Streamlit** — ett Python-bibliotek för att snabbt bygga interaktiva dashboards och webbapplikationer för data.
- **Dagster** — ett orkestreringsverktyg för att schemalägga och övervaka när dataflöden (pipelines) ska köras.
- **UV** — ett modernt, snabbt verktyg för att hantera Python-paket och virtuella miljöer.

### Kontrollfrågor

1. Varför används separata verktyg för inläsning (t.ex. DLT) respektive transformation (t.ex. DBT) istället för att göra allt i en enda stor process?
2. Vilken roll spelar Snowflake i den moderna dataverktygsstacken som presenteras, och hur skiljer sig dess arkitektur generellt från traditionella databaser?
3. Varför rekommenderas det att använda Git Bash istället för standardverktyg som PowerShell eller CMD i Windows vid kursens praktiska moment?
4. Vad är fördelen med att använda ett verktyg som Dagster för att orkestrera dina dataflöden istället för att köra skript manuellt?

## Lektion: Koppla Snowflake till Visual Studio Code

### Molnbaserat datalager (Snowflake Free Trial)

Snowflake är ett molnbaserat datalager där man under en provperiod (Free Trial) får tillgång till molnresurser, till exempel i form av krediter, för att bygga och testa datalösningar. Detta ger en riskfri och kostnadsfri miljö för att lära sig hantera molndatalager utan att behöva egen fysisk hårdvara.

### Integrering mellan molnlager och lokal IDE (VS Code)

Genom att installera Snowflakes officiella tillägg i Visual Studio Code och ansluta det till sitt Snowflake-konto via kontots unika URL (account identifier) kan man arbeta mot molndatalagret direkt från en lokal utvecklingsmiljö.

Detta möjliggör lokal utveckling av SQL-skript i en miljö som utvecklare redan känner igen, samtidigt som själva beräkningen (compute) sker i molnet. Genom att skriva koden lokalt kan man dessutom versionshantera sina SQL-filer, till exempel via Git, vilket ger ett smidigare arbetsflöde än att enbart arbeta i molnets webbläsargränssnitt.

### Tekniska termer

- **Account Identifier / URL** — den unika adressen till ett Snowflake-konto, används för att upprätta en säker anslutning från externa verktyg som VS Code.
- **Visual Studio Code Extension (Snowflake)** — ett tillägg till VS Code som tillåter interaktion med Snowflake-databaser direkt från källkodsredigeraren.
- **Fully Qualified Name (fullständigt kvalificerat namn)** — ett namngivningsmönster i SQL, till exempel `databas.schema.tabell`, som används för att tydligt peka ut exakt var en tabell ligger.
- **Query History (frågehistorik)** — en funktion i Snowflake som loggar alla exekverade frågor, vilken beräkningsresurs (warehouse) som användes och när de kördes.

### Kontrollfrågor

1. Varför är det fördelaktigt att skriva och exekvera sina SQL-skript lokalt i Visual Studio Code med Snowflake-tillägget istället för direkt i webbgränssnittet?
2. Vad är syftet med att använda ett så kallat "fully qualified name" när man frågar efter data från en specifik tabell i Snowflake?
3. Hur säkerställer systemet att dina lokala SQL-skript faktiskt körs mot molntjänsten, och var kan du verifiera att frågan har utförts?

## Lektion: Snowsight (Snowflakes webbgränssnitt)

### Snowsight

Snowsight är Snowflakes moderna webbaserade användargränssnitt där man interagerar med datalagret. Det ger en visuell överblick över beräkningsresurser, databaser, prestanda och kostnader, utan att man enbart behöver förlita sig på kommandoraden. I gränssnittet hanterar man beräkningsresurser (warehouses) och skapar SQL-worksheets för att köra frågor direkt i webbläsaren, samt utforskar katalogstrukturen med databaser, scheman och tabeller och förhandsgranskar data.

### Rollbaserad åtkomstkontroll (RBAC)

RBAC är en säkerhetsmodell där behörigheter knyts till specifika roller, som i sin tur tilldelas användare. Detta säkerställer att endast behörig personal har tillgång till känslig data och bidrar till att upprätthålla säkerheten i datalagret.

### Kostnads- och resurshantering (Compute & Billing)

Snowsight innehåller funktioner som visar hur mycket beräkningsresurserna (warehouses) har använts och vad det kostar. Eftersom molntjänster debiteras baserat på faktisk användning — förbrukade krediter för beräkning och lagring — är det kritiskt att övervaka detta för att undvika oväntade kostnader. Eftersom beräkning (compute) och lagring är separerade betalar man bara när beräkningsresurserna faktiskt är igång, vilket gör uppföljning i administrationsvyn viktig.

Avslutningsvis demonstreras även Snowflake Marketplace, där man kan hitta och hämta extern testdata.

### Tekniska termer

- **Snowsight** — Snowflakes moderna webbgränssnitt för utveckling, analys och administration.
- **Warehouse (beräkningsresurs)** — den virtuella maskin som tillhandahåller CPU och minne för att köra SQL-frågor och transformationer i Snowflake.
- **Database Explorer (katalog)** — den trädbaserade vyn i gränssnittet som visar organisationen av databaser, scheman och tabeller.
- **RBAC (Role-Based Access Control)** — en säkerhetsprincip som styr användarnas åtkomst baserat på deras tilldelade roller.
- **Snowflake Marketplace** — en plattform inuti Snowflake där organisationer kan dela, köpa eller ladda ner externa datamängder för analys.

### Kontrollfrågor

1. Varför är det viktigt att hålla koll på fliken för kostnadshantering (cost management) i ett molnbaserat datalager som Snowflake?
2. Hur skiljer sig syftet med en Snowflake "warehouse" (beräkningsresurs) från en vanlig tabellagring?
3. Vad innebär rollbaserad åtkomstkontroll (RBAC) och varför är det en viktig säkerhetsprincip i en centraliserad datamiljö?

## Lektion: Snowflakes arkitektur och teori

### Snowflakes flerskiktade arkitektur (Three-Tier Architecture)

Föreläsningen inleds med en jämförelse mellan traditionella on-premise-servrar, med höga fasta kapitalkostnader (CAPEX), och molnbaserade lösningar. Snowflake bygger på en flerskiktad arkitektur uppdelad i tre distinkta lager: molntjänster (cloud services), som hanterar säkerhet, autentisering, optimering och metadata; beräkningslagret (compute), det virtuella datalagret (virtual warehouse) som exekverar frågor; och lagringslagret (storage), den underliggande molnlagringen hos AWS, Azure eller GCP där data faktiskt sparas.

Anledningen till denna uppdelning är att den tillåter att lagring och beräkning helt separeras. Man kan skala upp eller ner de två oberoende av varandra, vilket eliminerar flaskhalsar som är typiska för traditionell, fast hårdvara.

### Skalbarhet: Scale-Up vs. Scale-Out

Scale-up (vertikal skalning) innebär att man ökar storleken på det virtuella lagret, till exempel från Extra Small till Large, för att hantera tunga och komplexa enskilda frågor. Scale-out (horisontell skalning) innebär istället att man lägger till flera kluster av samma storlek som körs parallellt, för att hantera många samtidiga användare eller arbetsbelastningar.

Denna uppdelning ger flexibilitet att anpassa prestandan efter typ av belastning — få tunga jobb kontra många lätta jobb — utan att betala för mer resurser än nödvändigt.

### Prismodell och kostnadskontroll

Kostnaden i Snowflake baseras på lagringsvolym per månad samt förbrukade krediter för beräkning, där debitering sker per sekund med en minsta debiteringsperiod på 1 minut. Detta möjliggör en pay-as-you-go-modell där man slipper stora initiala investeringar (CAPEX) och istället betalar rörligt baserat på faktisk användning.

### Objekt-hierarki och tabelltyper

Data i Snowflake organiseras i en hierarki: organisation → konto → warehouse/databas → schema → tabell. Utöver detta finns olika tabelltyper, bland annat temporära tabeller, transienta tabeller och permanenta tabeller, där permanenta tabeller har stöd för funktionerna Time Travel och Fail-safe. Denna struktur ger dels åtkomstkontroll, dels en säkerställning att data kan återställas vid oavsiktliga raderingar.

### Tekniska termer

- **CAPEX (Capital Expenditure)** — stora initiala kostnader för att köpa egen fysisk hårdvara, vilket undviks i molnet.
- **Virtual Warehouse** — en beräkningsresurs (kluster av noder) i Snowflake som tillhandahåller CPU och minne för att köra SQL-frågor.
- **Scale-Up / Scale-Out** — att öka storleken på en nod (scale-up) respektive lägga till flera parallella kluster (scale-out).
- **Time Travel** — en funktion i Snowflake som låter dig fråga efter, granska eller återställa historisk data från tidigare tidpunkter.
- **Transient Table** — en tabelltyp i Snowflake som saknar Time Travel och Fail-safe, vilket minskar lagringskostnaderna för tillfällig data.

### Kontrollfrågor

1. Hur skiljer sig Snowflakes molnbaserade arkitektur med separerad beräkning och lagring från traditionella on-premise-servrar när det gäller skalbarhet och kostnad?
2. När bör du välja att skala upp (scale-up) ditt virtuella lager snarare än att skala ut (scale-out)?
3. Vad är skillnaden mellan en permanent tabell och en transient tabell när det gäller funktioner som Time Travel och lagringskostnader?

## Lektion: Virtuella lager i Snowflake (kodning)

### Skapande och konfiguration av Virtual Warehouses via SQL (DDL)

Efter att en anslutning till Snowflake upprättats i Visual Studio Code via tillägget kan man använda DDL-kommandon (Data Definition Language) — `CREATE WAREHOUSE`, `ALTER WAREHOUSE` och `DROP WAREHOUSE` — för att programmatiskt styra beräkningsresurserna. Detta ger exakt kontroll över storlek (T-shirt-storlekar som `X-SMALL`, `SMALL` och så vidare) och beteende vad gäller kostnadsoptimering.

Parametrarna `AUTO_SUSPEND` och `AUTO_RESUME` är kritiska för att säkerställa att lagret stängs av automatiskt när det står inaktivt, vilket förhindrar att onödiga kostnader samlas på hög. Om tidsgränsen sätts för lågt finns dock en risk för frekventa stopp och starter, vilket i vissa fall kan påverka effektiviteten (t.ex. vid många korta, spridda frågor).

Ett virtuellt lager skapas med storlek och kostnadsparametrar direkt angivna:

```sql
CREATE WAREHOUSE DEMO_WAREHOUSE
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 60          -- sekunder inaktivitet innan avstängning
    AUTO_RESUME = TRUE;        -- startar automatiskt vid ny fråga
```

Ett befintligt lager kan därefter ändras, till exempel för att justera tidsgränsen eller (på Enterprise Edition) antalet parallella kluster för horisontell skalning:

```sql
ALTER WAREHOUSE DEMO_WAREHOUSE
    SET AUTO_SUSPEND = 120
        MAX_CLUSTER_COUNT = 2; -- kräver Enterprise Edition eller högre
```

När lagret inte längre behövs städas det bort för att stoppa eventuella framtida kostnader:

```sql
DROP WAREHOUSE DEMO_WAREHOUSE;
```

### Tekniska termer

- **CREATE WAREHOUSE** — DDL-kommando som används för att definiera och starta ett nytt virtuellt lager i Snowflake med valfri storlek och konfiguration.
- **Auto-suspend / Auto-resume** — funktioner som automatiskt sätter beräkningsresursen i viloläge efter en viss periods inaktivitet, respektive sätter igång den igen när en ny fråga skickas.
- **ALTER WAREHOUSE** — kommando för att ändra parametrar (t.ex. tidsgränser för auto-suspend eller klusterantal) på ett befintligt lager.
- **DROP WAREHOUSE** — kommando som permanent tar bort ett virtuellt lager och därmed stoppar eventuella framtida kostnader kopplade till det.

### Kontrollfrågor

1. Varför är parametrarna `AUTO_SUSPEND` och `AUTO_RESUME` viktiga när du konfigurerar ett virtuellt lager i en molnmiljö?
2. Vad händer om du försöker konfigurera flera parallella kluster (`MAX_CLUSTER_COUNT`) på ett virtuellt lager om ditt konto körs på Snowflake Standard Edition istället för Enterprise Edition?
3. Vilken risk kan finnas med att sätta en alltför kort tidsgräns för `AUTO_SUSPEND` (t.ex. 1 minut) om användaren kör många korta, spridda frågor efter varandra?

## Lektion: Roller och säkerhet i Snowflake

### Rollbaserad åtkomstkontroll (RBAC) och behörighetsarv

RBAC är en säkerhetsmodell där åtkomstprivilegier tilldelas roller, som i sin tur tilldelas användare eller andra roller i en hierarki. Detta gör det enkelt att hantera stora mängder användare genom att gruppera behörigheter, istället för att ge rättigheter till varje enskild användare.

Genom att bygga en hierarki av roller — där en överordnad roll är tilldelad en underordnad roll — ärvs alla privilegier automatiskt (privilege inheritance), vilket förenklar administrationen av säkerheten avsevärt jämfört med att hantera varje användares behörigheter separat.

### Systemdefinierade standardroller och principen om minsta privilegium

Snowflake har fördefinierade systemroller, till exempel `ORGADMIN`, `ACCOUNTADMIN`, `SECURITYADMIN`, `SYSADMIN`, `USERADMIN` och `PUBLIC`, med specifika ansvarsområden. Detta upprätthåller säkerheten genom att separera ansvarsområden mellan olika typer av administration.

Enligt principen om minsta privilegium (principle of least privilege) bör en användare aldrig ges högre behörighet än vad som krävs för dennes arbetsuppgifter. Till exempel bör man inte använda den allsmäktiga `ACCOUNTADMIN`-rollen för vardagliga uppgifter som att skapa databaser eller virtuella lager, utan istället använda `SYSADMIN`, som är avsedd för just den typen av objekthantering.

### Tekniska termer

- **RBAC (Role-Based Access Control)** — en säkerhetsmetod som styr tillgång till resurser baserat på användarens tilldelade roller.
- **Privilege Inheritance (behörighetsarv)** — principen att en roll som tilldelas en annan roll automatiskt övertar den underordnade rollens behörigheter.
- **ACCOUNTADMIN** — den högst rankade systemrollen i Snowflake, med fullständig kontroll över hela kontot.
- **SYSADMIN (System Administrator)** — en systemroll som ansvarar för att skapa och hantera objekt som databaser, tabeller och virtuella lager.
- **Principle of Least Privilege (minsta privilegiums princip)** — en säkerhetsprincip som innebär att en användare eller process endast ska ges de minimala rättigheter som krävs för att utföra sin uppgift.

### Kontrollfrågor

1. Varför är det viktigt att följa principen om minsta privilegium när man tilldelar roller till användare i ett datalager som Snowflake?
2. Hur fungerar behörighetsarv (privilege inheritance) i en rollhierarki, och vilka fördelar ger det vid administration av många användare?
3. Varför rekommenderas det att använda `SYSADMIN` istället för `ACCOUNTADMIN` när du till exempel skapar nya virtuella lager eller databaser?

## Lektion: RBAC i Snowflake (praktisk kodning)

### Användning av systemroller för olika ansvarsområden (Separation of Concerns)

I den praktiska genomgången används konsekvent rätt systemdefinierade roll för specifika administrativa uppgifter: `SYSADMIN` för att skapa databaser, virtuella lager och tabeller; `USERADMIN` för att skapa nya roller; och `SECURITYADMIN` för att hantera behörigheter och grants. Detta upprätthåller god säkerhetspraxis och följer principen om minsta privilegium genom att man undviker att ständigt använda den allsmäktiga `ACCOUNTADMIN`-rollen.

Som `SYSADMIN` byggs grundstrukturen upp — databas, lager och tabeller för rådata:

```sql
USE ROLE SYSADMIN;

CREATE WAREHOUSE dev_wh
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE;

CREATE DATABASE ice_cream_db;

USE DATABASE ice_cream_db;

CREATE TABLE raw_customers (...);
CREATE TABLE raw_orders (...);
CREATE TABLE raw_products (...);
```

### Skapande av anpassade roller och behörighetsstyrning (RBAC)

Anpassade roller definieras för olika ansvarsområden, exempelvis en läsare, en skrivare och en analytiker. Med SQL-kommandon (`GRANT ROLE`, `GRANT USAGE`, `GRANT SELECT`/`INSERT`) styrs sedan exakt vad varje roll får göra i databasen. På så sätt kan man till exempel begränsa en rapportanvändare eller ett analysverktyg till att endast läsa data, medan ETL-processer får skriva data.

Som `USERADMIN` skapas rollerna:

```sql
USE ROLE USERADMIN;

CREATE ROLE reader_role;
CREATE ROLE writer_role;
CREATE ROLE analyst_role;
```

Som `SECURITYADMIN` beviljas därefter behörigheter — både `USAGE` på lager och databas (krävs för att en roll överhuvudtaget ska kunna använda dem) och specifika CRUD-rättigheter på tabellnivå:

```sql
USE ROLE SECURITYADMIN;

GRANT USAGE ON WAREHOUSE dev_wh TO ROLE reader_role;
GRANT USAGE ON DATABASE ice_cream_db TO ROLE reader_role;
GRANT SELECT ON ALL TABLES IN SCHEMA ice_cream_db.public TO ROLE reader_role;

GRANT USAGE ON WAREHOUSE dev_wh TO ROLE writer_role;
GRANT USAGE ON DATABASE ice_cream_db TO ROLE writer_role;
GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA ice_cream_db.public TO ROLE writer_role;

GRANT ROLE reader_role TO USER some_user;
```

I den avslutande praktiska testningen uppmärksammas att Snowflakes VS Code-tillägg automatiskt kan aktivera sekundära roller (secondary roles) vid sidan av den primära rollen. Det innebär att behörigheter kan överlappa på ett sätt som gör det svårt att lita på att man verkligen testar en strikt, begränsad roll om man inte är uppmärksam på vilka roller som faktiskt är aktiva.

### Tekniska termer

- **SYSADMIN** — systemrollen som ansvarar för att skapa och hantera objekt som databaser, scheman, tabeller och virtuella lager.
- **USERADMIN** — systemrollen som har behörighet att hantera användare och skapa nya roller.
- **SECURITYADMIN** — systemrollen som hanterar globala behörigheter, grants och säkerhetsregler.
- **DCL (Data Control Language)** — SQL-kommandon som används för att styra behörigheter, t.ex. `GRANT` och `REVOKE`.
- **Secondary Roles (sekundära roller)** — en funktion i bland annat Snowflakes VS Code-tillägg som automatiskt aktiverar alla roller en användare tilldelats vid sidan av den primära rollen, vilket kan påverka vilka behörigheter som faktiskt slår igenom.

### Kontrollfrågor

1. Varför är det viktigt att växla till rätt systemroll (`SYSADMIN`, `USERADMIN` respektive `SECURITYADMIN`) istället för att utföra alla administrativa uppgifter som `ACCOUNTADMIN`?
2. Vad innebär det att bevilja `USAGE`-privilegier på ett virtuellt lager respektive en databas för en specifik roll, och varför krävs båda?
3. Hur kan funktionen med sekundära roller (secondary roles) i utvecklingsmiljön (som VS Code) påverka testningen av strikta läsbehörigheter, och vad bör man tänka på?

## Lektion: Data Load Tool (DLT) och extrahering/laddning (teori)

### Datalagrets arkitekturlager (Staging, Warehouse, Mart)

Datalagret delas upp i lager där data flödar genom olika stadier. Staging-lagret innehåller rådata som lästs in direkt från källsystemen — det är detta lager som DLT fokuserar på. Warehouse-lagret innehåller renoverad, strukturerad och modellerad data, till exempel via dimensionell modellering. Mart-lagret är det yttersta lagret, med affärsspecifika vyer eller tabeller anpassade för slutanvändare, dashboards eller AI-modeller.

Denna uppdelning ger en tydlig struktur som skiljer rådata från affärslogik och rapportering, vilket underlättar underhåll och felsökning.

### Varför specialiserade data load-verktyg behövs istället för egna skript

Istället för att data engineers lägger tid på att skriva egna anpassade skript för varje datakälla används färdiga verktyg med inbyggda anslutningar (connectors). Egenbyggda skript blir ofta sköra och svårunderhållna, och de går sönder när källsystemen förändras. Specialiserade verktyg hanterar istället felhantering, inkrementell laddning och anslutningar automatiskt, vilket sparar tid som annars går åt till att uppfinna hjulet på nytt — tid som i stället kan läggas på kärnuppgifter som datamodellering och analys.

### DLT (Data Load Tool) i Modern Data Stack

DLT är ett Python-baserat open source-verktyg, och ett av flera alternativ på marknaden vid sidan av till exempel Fivetran, Airbyte och Azure Data Factory. Det automatiserar "E"- och "L"-fasen i ELT genom att erbjuda färdiga kopplingar och en lättviktsmiljö för att skicka data direkt från olika källor till ett molndatalager som Snowflake.

### Tekniska termer

- **DLT (Data Load Tool)** — ett Python-bibliotek och open source-verktyg för att extrahera och ladda data.
- **Staging Layer (staging-lager)** — det första lagret i datalagret där rådata tas emot från källsystemen.
- **Mart Layer (mart-lager)** — det yttersta lagret, skräddarsytt för affärsanalys, dashboards eller maskininlärning.
- **Connectors (kopplingar)** — fördefinierade moduler som hanterar kommunikationen mellan en specifik datakälla (t.ex. ett API eller en databas) och laddningsverktyget.
- **ELT (Extract, Load, Transform)** — ett dataflödesmönster där data först extraheras och laddas till datalagret i sitt råformat, för att sedan transformeras internt.

### Kontrollfrågor

1. Varför rekommenderas det att använda ett färdigt data load-verktyg (som DLT eller Airbyte) framför att skriva egna anpassade skript för dataextrahering?
2. Vad är syftet med att dela upp datalagret i olika skikt (såsom staging, warehouse och mart), och vilket skikt fyller DLT funktionen för?
3. Hur skiljer sig ELT-modellen (som används här) från den traditionella ETL-modellen när det gäller var transformationen av data äger rum?

## Lektion: Extrahera och ladda CSV-data till Snowflake med DLT (praktisk kodning)

### Praktisk ELT-pipeline med DLT och Python

Ett Python-skript definierar en DLT-resurs som läser in en CSV-fil (i exemplet Netflix-data), hanterar konfigurationen och skickar in datan i ett specificerat schema (staging) i molndatalagret. Detta automatiserar inläsningen utan att man behöver bygga egna, komplexa skript från grunden — DLT skapar dessutom automatiskt rätt datatyper och tabellstrukturer i måldatalagret utifrån källdatan.

En DLT-pipeline definierar källan, destinationen (t.ex. Snowflake) och vilket schema datan ska landa i:

```python
import dlt

@dlt.resource(write_disposition="replace")
def netflix_titles():
    import csv
    with open("data/netflix_titles.csv", encoding="utf-8") as f:
        yield from csv.DictReader(f)

pipeline = dlt.pipeline(
    pipeline_name="netflix_csv_pipeline",
    destination="snowflake",
    dataset_name="staging",
)

if __name__ == "__main__":
    load_info = pipeline.run(netflix_titles())
    print(load_info)
```

`write_disposition` styr hur DLT hanterar data vid uppdatering av tabeller — till exempel `replace` (skriv över), `append` (lägg till) eller `merge` (sammanfoga).

### Konfiguration av hemligheter och anslutningsdetaljer (secrets.toml)

Anslutningsuppgifter till Snowflake — användarnamn, lösenord, kontoidentifierare med mera — lagras i en separat konfigurationsfil, `secrets.toml`, istället för att skrivas direkt i källkoden:

```toml
[destination.snowflake.credentials]
database = "ice_cream_db"
username = "dlt_loader"
password = "..."
account = "xxxxxxx-xxxxxxx"
warehouse = "dev_wh"
role = "dlt_loader_role"
```

Detta förhindrar att känsliga uppgifter läcker ut, till exempel vid publicering av koden på GitHub.

### Behörighetsstyrning för laddningsprocessen (Service Accounts / Roles)

Istället för att köra inläsningen med ett administratörskonto skapas en dedikerad roll och användare för DLT, med enbart de rättigheter som krävs (t.ex. att infoga, uppdatera och radera i staging-schemat), samt en separat läsarroll för analys:

```sql
USE ROLE SECURITYADMIN;

CREATE ROLE dlt_loader_role;

GRANT USAGE ON WAREHOUSE dev_wh TO ROLE dlt_loader_role;
GRANT USAGE ON DATABASE ice_cream_db TO ROLE dlt_loader_role;
GRANT CREATE SCHEMA ON DATABASE ice_cream_db TO ROLE dlt_loader_role;
GRANT ALL ON SCHEMA ice_cream_db.staging TO ROLE dlt_loader_role;

GRANT ROLE dlt_loader_role TO USER dlt_loader;
```

Detta följer principen om minsta privilegium och säkerställer att inläsningsskriptet endast har de behörigheter det faktiskt behöver för sitt arbete.

Avslutningsvis installeras nödvändiga paket i en virtuell miljö med hjälp av `uv`, pipelinen körs, och resultatet verifieras genom att kontrollera att tabellerna och schemat har skapats korrekt i Snowflake.

### Tekniska termer

- **DLT Pipeline** — ett Python-baserat dataflöde som definierar källan, destinationen (t.ex. Snowflake) och vilket schema (staging) datan ska landa i.
- **secrets.toml** — en konfigurationsfil som används av DLT för att hantera känsliga inloggningsuppgifter och anslutningssträngar.
- **Staging Schema** — det schemalager i datalagret där rådata från inläsningen först landar, innan vidare transformation.
- **Disposition (Replace / Append / Merge)** — regler för hur DLT ska hantera data vid uppdatering av tabeller: skriva över, lägga till eller sammanfoga.
- **uv** — ett modernt och mycket snabbt verktyg för att hantera Python-paket och virtuella miljöer.

### Kontrollfrågor

1. Varför är det viktigt att separera anslutningsdetaljer och lösenord i en fil som `secrets.toml` istället för att skriva dem direkt i Python-koden?
2. Hur skapar DLT tabellstrukturen och datatyperna i Snowflake när en CSV-fil läses in för första gången?
3. Varför rekommenderas det att skapa en dedikerad användare och roll (t.ex. för DLT-inläsningen) med begränsade behörigheter istället för att utföra inläsningen med administratörskontot (`ACCOUNTADMIN`)?

## Lektion: Extrahera data från API med DLT (teori)

### API som datakälla i ELT-processen

Ett API (Application Programming Interface) används för att hämta data från externa system eller webbapplikationer, istället för att bara läsa från statiska filer. De flesta moderna tjänster — vädertjänster, marknadsföringsplattformar, affärssystem med flera — exponerar sin data via API:er, vilket gör dem till en av de vanligaste datakällorna för data engineering-pipelines.

Med DLT kan man automatisera skickandet av GET-förfrågningar till API:et, tolka svaret och ladda in den strukturerade datan direkt i datalagrets staging-lager. DLT hanterar dessutom anslutningen till måldatalagret med hjälp av lagrade hemligheter och konfigurationsfiler, på samma sätt som vid CSV-inläsning.

### Tekniska termer

- **API (Application Programming Interface)** — ett mjukvarugränssnitt som gör det möjligt för olika system att kommunicera och utbyta data med varandra.
- **GET-anrop** — en förfrågan som skickas till ett API för att hämta data.
- **Destination (mål)** — den slutgiltiga lagringsplatsen för datan i ELT-processen, i detta fall molndatalagret Snowflake.

### Kontrollfrågor

1. Varför är API:er en vanligare och mer dynamisk datakälla i moderna dataflöden jämfört med statiska CSV-filer?
2. Vilken roll spelar DLT när data ska hämtas från ett externt API och flyttas till ett molndatalager som Snowflake?
3. Vad behöver lagras säkert (t.ex. i konfigurationsfiler) för att en anslutning mellan DLT, ett API och Snowflake ska fungera?

## Lektion: Extrahera och ladda API-data till Snowflake med DLT (praktisk kodning)

### Inläsning av API-data i molndatalagret med DLT

Python och DLT används för att automatiskt skicka förfrågningar till ett externt API — i exemplet det svenska jobb-API:et (JobTech/Platsbanken) — och ladda in svaret i ett staging-lager i Snowflake. Detta automatiserar hämtningen av dynamisk data som uppdateras kontinuerligt av externa aktörer.

API-svar innehåller ofta en komplex, kapslad (nested) JSON-struktur. DLT hanterar detta automatiskt genom att platta ut eller strukturera datan i separata, relaterade tabeller i Snowflake, vilket sparar tid jämfört med att manuellt bygga logik för att packa upp nästlade objekt och listor.

Innan kodningen sätts en lokal utvecklingsmiljö upp med en virtuell miljö (`uv`/`pip`) samt en `.gitignore`-fil som säkerställer att känsliga filer som `secrets.toml` aldrig checkas in i versionshanteringen:

```
# .gitignore
.venv/
secrets.toml
.env
```

Själva pipelinen definierar en resurs som hämtar data från API:et och skickar den vidare till Snowflake:

```python
import dlt
import requests

@dlt.resource(write_disposition="replace")
def job_ads():
    response = requests.get("https://jobsearch.api.jobtechdev.se/search")
    response.raise_for_status()
    data = response.json()
    yield from data["hits"]

pipeline = dlt.pipeline(
    pipeline_name="job_ads_pipeline",
    destination="snowflake",
    dataset_name="staging",
)

if __name__ == "__main__":
    load_info = pipeline.run(job_ads())
    print(load_info)
```

Efter körning verifieras resultatet via SnowSQL och Snowsight, där man bland annat kan se hur DLT har skapat separata tabeller för kapslade listor/objekt i JSON-svaret, länkade till huvudtabellen via genererade nycklar.

### Dedikerade säkerhetsroller och principer för inläsning (Service Accounts)

En specifik användare (`extract_loader`) och en specifik roll (`job_ads_dlt_role`) skapas med exakt de CRUD-rättigheter som krävs i staging-schemat, utan att använda administrativa konton. Detta följer principen om minsta privilegium och isolerar inläsningsprocessen från övriga delar av datalagret.

```sql
USE ROLE SECURITYADMIN;

CREATE ROLE job_ads_dlt_role;

GRANT USAGE ON WAREHOUSE dev_wh TO ROLE job_ads_dlt_role;
GRANT USAGE ON DATABASE ice_cream_db TO ROLE job_ads_dlt_role;
GRANT ALL ON SCHEMA ice_cream_db.staging TO ROLE job_ads_dlt_role;

GRANT ROLE job_ads_dlt_role TO USER extract_loader;
```

### Tekniska termer

- **API (Application Programming Interface)** — det externa gränssnitt som anropas för att samla in data (i exemplet: Arbetsförmedlingens jobb-API).
- **Kapslad data (Nested JSON)** — data som innehåller objekt eller listor inuti andra objekt, vanligt vid API-svar, och som hanteras automatiskt av laddningsverktyget.
- **Staging Schema** — det första mottagningslagret i Snowflake där API-datan landar i sitt ursprungliga format, innan vidare transformation.

### Kontrollfrågor

1. Hur hanterar DLT den komplexa och kapslade strukturen (JSON) som ofta returneras vid anrop till ett externt API när datan laddas in i tabeller?
2. Varför rekommenderas det att skapa en separat användare (`extract_loader`) och roll (`job_ads_dlt_role`) enbart för API-inläsningen istället för att använda ditt personliga administratörskonto?
3. Vad är syftet med att begränsa rättigheterna till endast det specifika staging-schemat för inläsningsprocessen?

## Lektion: Dimensionell modellering och stjärnscheman (teori)

### Dimensionell modellering enligt Kimball-metodiken (Stjärnschema)

Dimensionell modellering enligt Ralph Kimballs metodik strukturerar datalagret i ett stjärnschema: en central faktatabell, som innehåller mätbara värden och transaktioner, omgiven av dimensionstabeller, som innehåller kontext och beskrivande attribut. Detta placeras i dataflödet mellan staging-lagret och warehouse-lagret — det är i denna transformation datan formas om till stjärnschemat.

Denna struktur gör datan intuitiv och lättförståelig för både tekniska och icke-tekniska intressenter, samtidigt som den optimerar prestandan för komplexa analysfrågor i OLAP-miljöer.

### Granularitet (Grain) och atomära nivåer

Granularitet är nivån av detaljrikedom i en faktatabell, till exempel enskild transaktion jämfört med dags- eller månadssummering. Att välja en så låg (atomär) granularitet som möjligt är avgörande, eftersom man aldrig i förväg kan förutsäga alla framtida affärsbehov.

Om data sparas på enskild transaktionsnivå kan man enkelt aggregera upp den till dagar eller månader vid behov. Sparar man däremot direkt på månadsnivå går det inte att i efterhand gå tillbaka och få ut tim- eller dagsdata. Lägre granularitet ger därför maximal flexibilitet för att möta nya krav som uppstår senare.

### Faktatabeller vs. dimensionstabeller och denormalisering

Faktatabeller innehåller kvantitativa, mätbara värden, till exempel antal besök eller kostnader. Dimensionstabeller innehåller istället beskrivande kontext — som datum, patient eller sjukhus — och kopplas till faktatabellen via primär- och främmande nycklar.

Denormalisering innebär att man medvetet undviker att dela upp data i många små, normaliserade tabeller till förmån för bredare dimensionstabeller. Detta minskar antalet tunga kopplingar (joins) som databasen behöver göra, vilket drastiskt förbättrar frågeprestandan och gör modellen enklare att förstå för verksamheten, jämfört med den höggradiga normalisering man normalt eftersträvar i operativa OLTP-system.

### Tekniska termer

- **Stjärnschema (Star Schema)** — en databasstruktur med en central faktatabell omgiven av ett "stjärnmönster" av dimensionstabeller.
- **Faktatabell (Fact Table)** — en tabell som lagrar kvantitativa och mätbara händelser, t.ex. försäljning eller besök.
- **Dimensionstabell (Dimension Table)** — en tabell som tillhandahåller kontext och beskrivande attribut till fakta (t.ex. vem, var, när).
- **Granularitet (Grain)** — graden av detaljrikedom i data.
- **Atomär granularitet (Atomic Grain)** — den lägsta möjliga detaljnivån för data, t.ex. enskilda transaktioner.
- **Främmande nyckel / primärnyckel (Foreign Key / Primary Key)** — mekanismen som kopplar samman faktatabeller med dimensionstabeller.
- **Denormalisering** — principen att hålla tabeller breda och o-normaliserade för att gynna prestanda och användarvänlighet i datalager.

### Kontrollfrågor

1. Varför rekommenderas det att eftersträva en så låg (atomär) granularitet som möjligt när man designar en faktatabell?
2. Hur skiljer sig syftet och innehållet mellan en faktatabell och en dimensionstabell i ett stjärnschema?
3. Varför tillämpar man denormalisering i stjärnscheman istället för att normalisera databasen på samma sätt som i traditionella operativa system (OLTP)?

## Lektion: Datamarknader (Data Marts) och servering av data

### Datamarknader (Data Marts) och avdelningsspecifik struktur

Ett Data Mart är ett avgränsat skikt i datalagret (eller en specifik schema-struktur) som bygger på stjärnscheman och är skräddarsytt för en specifik avdelning eller grupp av intressenter, till exempel HR, försäljning eller marknadsföring. Istället för att slutanvändare och BI-verktyg frågar mot rådata eller hela det komplexa datalagret får de tillgång till färdigstrukturerade, relevanta och prestandaoptimerade vyer.

### SQL-kopplingar och berikning av data (Joins & CTEs)

Common Table Expressions (CTE) och JOINs på främmande nycklar används för att sammanfoga faktatabeller med dimensionstabeller till en sammanhållen, berikad vy där all nödvändig kontext finns tillgänglig på ett ställe. I föreläsningens exempel byggs en datamarknad för jobbannonser genom att berika en faktatabell med kontext från dimensionstabeller:

```sql
WITH job_ads_enriched AS (
    SELECT
        f.job_ad_id,
        f.published_date,
        d_employer.employer_name,
        d_location.municipality,
        d_occupation.occupation_field
    FROM fct_job_ads AS f
    JOIN dim_employer AS d_employer
        ON f.employer_id = d_employer.employer_id
    JOIN dim_location AS d_location
        ON f.location_id = d_location.location_id
    JOIN dim_occupation AS d_occupation
        ON f.occupation_id = d_occupation.occupation_id
)
SELECT * FROM job_ads_enriched;
```

Genom att göra dessa transformationer och berikningar i datalagret, innan datan når BI-verktyget, säkerställer man att alla rapporter visar samma siffror och att rapportverktyget slipper göra tunga beräkningar i realtid. BI-verktyg och dashboards bör därför hämta sin data direkt från datamarknaderna, istället för att själva göra tunga transformationer.

### Tekniska termer

- **Data Mart (datamarknad)** — en undergrupp av ett datalager fokuserad på en specifik affärsverksamhet eller avdelning.
- **CTE (Common Table Expression)** — ett tillfälligt resultatset i SQL, definierat med `WITH`-satsen, som gör komplexa frågor mer läsbara och strukturerade.
- **JOIN** — en SQL-operation som kopplar samman rader från två eller flera tabeller baserat på ett relaterat fält (främmande nyckel).

### Kontrollfrågor

1. Vad är syftet med att skapa separata datamarknader (Data Marts) för olika avdelningar i stället för att låta alla använda samma generella datalager?
2. Varför rekommenderas det att göra tunga sammanfogningar (JOINs) och databearbetningar i datalagret snarare än direkt i BI- och rapportverktyget?
3. Hur används främmande nycklar (foreign keys) när man bygger ihop faktatabeller och dimensionstabeller till en datamarknad?

## Lektion: dbt (data build tool) — teoretiska grunder

### dbt (Data Build Tool) och transformering med SQL + Jinja

dbt (`dbt core`) är ett open source-verktyg som låter dig transformera data i datalagret med hjälp av modulära SQL-filer och Jinja, ett mallningsspråk med dubbla klamrar (`{{ }}`) för till exempel referenser och makron. Det ger mjukvaruutvecklingsprinciper till data engineering — som versionshantering, modularitet och DRY (Don't Repeat Yourself) — istället för att man skriver spretiga och svårunderhållna SQL-skript.

dbt kompilerar den dbt-specifika koden, med bland annat `ref`-funktioner, till ren rå-SQL som skickas och körs direkt i datalagret (t.ex. Snowflake). Detta förenklar felsökning och beroendehantering, eftersom man aldrig hårdkodar tabellnamn utan istället refererar till andra modeller:

```sql
-- models/marts/fct_orders.sql
select
    o.order_id,
    o.order_date,
    c.customer_name
from {{ ref('stg_orders') }} as o
join {{ ref('dim_customers') }} as c
    on o.customer_id = c.customer_id
```

`{{ ref(...) }}` bygger automatiskt upp beroendekedjan (lineage) mellan modellerna, istället för att man skriver ut fullständiga, hårdkodade tabellnamn.

### Data Lineage (dataflödeslinjer) och automatiskt genererad dokumentation

dbt genererar en webbaserad dokumentation som visuellt visar beroenden mellan olika modeller, från staging via warehouse till de slutliga marts-modellerna (data lineage). Det ger full spårbarhet och gör det enkelt att se vilka tabeller eller vyer som påverkas om en källtabell förändras, både uppströms och nedströms.

### Inbyggda datatester

dbt har deklarativa tester som definieras i YAML-filer, till exempel för att kontrollera att ID-kolumner är unika eller att vissa fält inte är `NULL`:

```yaml
# models/marts/schema.yml
models:
  - name: fct_orders
    columns:
      - name: order_id
        tests:
          - unique
          - not_null
```

Detta kvalitetssäkrar automatiskt att datan som flödar genom transformationerna är korrekt, vilket bevarar intressenternas förtroende för datateamet.

Slutligen organiseras ett dbt-projekt i en tydlig filstruktur, med bland annat mappar för modeller och makron samt en huvudkonfigurationsfil, `dbt_project.yml`, som definierar hur projektet ska byggas och struktureras.

### Tekniska termer

- **dbt (Data Build Tool)** — ett verktyg för att hantera datatransformationer i ett datalager genom kodbaserade modeller.
- **Jinja** — ett mallningsspråk som används i dbt (med `{{ }}`) för att skriva dynamisk SQL och återanvända kod.
- **dbt Ref (`{{ ref(...) }}`)** — en funktion i dbt som automatiskt bygger upp beroendekedjan (lineage) mellan olika modeller, istället för hårdkodade tabellnamn.
- **Data Lineage** — en visuell graf över hur data flödar och är beroende av varandra genom olika transformationssteg.
- **dbt Project (`dbt_project.yml`)** — huvudkonfigurationsfilen som definierar hur dbt-projektet ska byggas och struktureras.

### Kontrollfrågor

1. Hur skiljer sig dbt från traditionella SQL-skript när det gäller att hantera beroenden mellan olika tabeller och vyer i datalagret?
2. Vad fyller funktionen Data Lineage för roll i ett dbt-projekt, och varför är det till nytta för en data engineer?
3. Varför är det viktigt att inkludera automatiska datatester i dbt-projektet innan data når slutna intressenter i marts-lagret?

## Lektion: dbt-modellering i praktiken med Snowflake

### Praktisk dbt-modellering i skikt (Staging → Warehouse → Marts)

dbt-modellerna organiseras i mappar som motsvarar datalagrets arkitekturskikt. Staging-modellerna rensar och läser in rådata från källan, ofta materialiserade som ephemeral (temporära) vyer. Warehouse-modellerna bygger upp stjärnschemat, med en faktatabell (t.ex. `fact_job_ads`) och tillhörande dimensionstabeller (t.ex. `dim_occupation`). Marts-modellerna skapar därefter färdiga, avdelningsspecifika vyer (t.ex. `mart_technical_jobs`) som är redo för analys och rapportering.

Denna uppdelning ger tydlig modularitet, gör koden enklare att underhålla och säkerställer att logiken följer best practices inom data engineering.

### Konfiguration av dbt-projekt och profiler (profiles.yaml)

dbt-projektet (`dbt_project.yml`) kopplas ihop med Snowflake via en lokal profilfil, `profiles.yaml`, som normalt placeras i användarens hemkatalog och hanterar inloggningsuppgifter och anslutningar:

```yaml
# ~/.dbt/profiles.yaml
job_ads_project:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: xxxxxxx-xxxxxxx
      user: transformer
      role: transformer_role
      database: ice_cream_db
      warehouse: dev_wh
      schema: warehouse
      authenticator: username_password_mfa
```

Detta separerar projektets kod från känsliga anslutningsuppgifter och gör att dbt kan kommunicera direkt med rätt datalager och schema.

### Materialisering och exekvering (dbt run)

Kommandot `dbt run` kompilerar dbt-modellerna till ren SQL och exekverar dem i Snowflake, vilket skapar tabeller eller vyer beroende på hur respektive modell är materialiserad:

```bash
dbt run
```

En modell kan till exempel materialiseras som ephemeral, vilket innebär att den inte lagras som en fysisk tabell eller vy i databasen, utan istället exekveras som en inline-subquery när andra modeller refererar till den — vanligt för staging-modeller som bara är ett mellansteg:

```sql
{{ config(materialized='ephemeral') }}

select
    id as job_ad_id,
    occupation_id,
    published_date
from {{ source('staging', 'job_ads') }}
```

Efter att `dbt run` körts verifieras resultatet i Snowsight genom att inspektera staging-, warehouse- och mart-lagren och kontrollera att tabellerna och vyerna har skapats som förväntat.

### Tekniska termer

- **dbt Run** — kommandot som bygger och exekverar dbt-modellerna i datalagret.
- **Ephemeral** — en materialiseringstyp i dbt där modellen inte lagras som en fysisk tabell eller vy i databasen, utan exekveras som en inline-subquery när andra modeller refererar till den.
- **profiles.yaml** — konfigurationsfilen som lagrar anslutningsdetaljer och autentiseringsuppgifter för dbt mot molndatalagret.
- **Stjärnschema (Star Schema)** — den dimensionella modell som implementeras i warehouse-lagret, med en faktatabell i mitten omgiven av dimensioner.

### Kontrollfrågor

1. Varför är det fördelaktigt att dela upp dbt-modellerna i olika skikt (staging, warehouse och marts) istället för att samla all transformationslogik i en enda stor SQL-fil?
2. Vad är skillnaden mellan att materialisera en dbt-modell som en fysisk tabell i Snowflake jämfört med att använda materialiseringen ephemeral?
3. Vilken roll spelar filen `profiles.yaml` i din lokala utvecklingsmiljö när du arbetar med dbt och Snowflake?

## Lektion: Datatester i dbt

### Inbyggda och utökade datatester i dbt (schema.yml)

Datatester i dbt är deklarativa tester som skrivs i YAML-filer för att validera datakvaliteten i modellerna — till exempel att primärnycklar är unika och inte saknar värden, eller att relationer mellan tabeller stämmer. Detta gör det möjligt att automatiskt upptäcka fel, buggar eller förändringar i källdata innan felaktig information når slutna intressenter eller dashboards.

Grundläggande tester som `unique` och `not_null` definieras för enskilda kolumner:

```yaml
# models/warehouse/schema.yml
models:
  - name: fact_job_ads
    columns:
      - name: job_ad_id
        tests:
          - unique
          - not_null
      - name: occupation_id
        tests:
          - not_null
          - relationships:
              to: ref('dim_occupation')
              field: occupation_id
```

Ett relationstest (`relationships`) verifierar att en främmande nyckel i en tabell faktiskt existerar som primärnyckel i en annan tabell — här att varje `occupation_id` i faktatabellen finns som en giltig rad i `dim_occupation`. Det är särskilt viktigt mellan faktatabeller och dimensionstabeller, eftersom ett brutet samband annars kan ge tysta, felaktiga kopplingar i rapporteringen.

Alla definierade tester körs med:

```bash
dbt test
```

### Användning av externa testpaket (dbt-expectations)

`dbt-expectations` är ett populärt dbt-paket, inspirerat av verktyget Great Expectations, som tillhandahåller ett stort utbud av färdiga testmakron för mer avancerad dataverifiering — till exempel genomsnittsvärden, kvantiler, värdeintervall eller strängmatchning. Det sparar tid genom att man slipper skriva egna, komplexa SQL-tester för denna typ av statistiska kontroller.

Paketet läggs till i `packages.yml` och installeras därefter:

```yaml
# packages.yml
packages:
  - package: calogica/dbt_expectations
    version: [">=0.10.0", "<0.11.0"]
```

```bash
dbt deps
```

Ett exempel på ett statistiskt test är att kontrollera att värden ligger inom ett rimligt intervall, till exempel antal lediga tjänster per annons mellan 0 och 20, med möjlighet att bara varna (`warn`) istället för att krascha hela körningen:

```yaml
models:
  - name: fact_job_ads
    columns:
      - name: number_of_vacancies
        tests:
          - dbt_expectations.expect_column_values_to_be_between:
              min_value: 0
              max_value: 20
              config:
                severity: warn
```

Genom att kombinera standardtester med statistiska gränser kan man upptäcka om data avviker från det normala, vilket skyddar mot missvisande analysunderlag längre fram i kedjan.

### Tekniska termer

- **dbt deps** — kommandot som laddar ner och installerar externa dbt-paket definierade i `packages.yml`.
- **dbt-expectations** — ett populärt dbt-paket för avancerade datakvalitets- och valideringstester.
- **Unique & Not Null** — standardtester i dbt som säkerställer att en kolumn inte innehåller dubbletter eller null-värden.
- **Relationships (relationstest)** — ett test som verifierar att främmande nycklar i en tabell faktiskt existerar som primärnycklar i en annan tabell.
- **dbt test** — kommandot som exekverar alla definierade tester mot databasen.

### Kontrollfrågor

1. Vad är skillnaden mellan dbt:s inbyggda grundtester (som `unique` och `not_null`) och de mer avancerade testerna som tillhandahålls av paketet `dbt-expectations`?
2. Hur fungerar ett relationstest (`relationships`) i dbt, och varför är det viktigt att använda det mellan faktatabeller och dimensionstabeller?
3. Varför är det kritiskt att integrera automatiska datatester i din data pipeline innan rapporterna når ut till verksamhetens beslutsfattare?

## Lektion: Streamlit-dashboard för jobbannonser (praktisk kodning)

### Dedikerat säkerhetskonto och läsarroll för BI/rapportering

Innan dashboarden byggs skapas en specifik användare (`reporter`) och en roll (`job_ads_reporter_role`) som enbart har `SELECT`-behörigheter, utan CRUD eller skrivrättigheter, på mart-lagret i Snowflake:

```sql
USE ROLE SECURITYADMIN;

CREATE ROLE job_ads_reporter_role;

GRANT USAGE ON WAREHOUSE dev_wh TO ROLE job_ads_reporter_role;
GRANT USAGE ON DATABASE ice_cream_db TO ROLE job_ads_reporter_role;
GRANT USAGE ON SCHEMA ice_cream_db.marts TO ROLE job_ads_reporter_role;
GRANT SELECT ON ALL TABLES IN SCHEMA ice_cream_db.marts TO ROLE job_ads_reporter_role;

GRANT ROLE job_ads_reporter_role TO USER reporter;
```

Detta följer principen om minsta privilegium: applikationer eller dashboards som konsumerar data bör aldrig köra på administrativa konton, vilket minskar risken för oavsiktlig åverkan på data.

### Anslutning mellan Python/Streamlit och Snowflake via miljövariabler

Nödvändiga paket — bland annat `streamlit`, `pandas` och `snowflake-connector-python` — installeras i en virtuell miljö. En separat anslutningsmodul läser in anslutningsdetaljerna från en `.env`-fil, istället för att hårdkoda lösenord i källkoden:

```
# .env
SNOWFLAKE_ACCOUNT=xxxxxxx-xxxxxxx
SNOWFLAKE_USER=reporter
SNOWFLAKE_PASSWORD=...
SNOWFLAKE_ROLE=job_ads_reporter_role
SNOWFLAKE_WAREHOUSE=dev_wh
SNOWFLAKE_DATABASE=ice_cream_db
SNOWFLAKE_SCHEMA=marts
```

```python
# connect_data_warehouse.py
import os
import pandas as pd
import snowflake.connector
from dotenv import load_dotenv

load_dotenv()

def get_dataframe(query: str) -> pd.DataFrame:
    conn = snowflake.connector.connect(
        account=os.environ["SNOWFLAKE_ACCOUNT"],
        user=os.environ["SNOWFLAKE_USER"],
        password=os.environ["SNOWFLAKE_PASSWORD"],
        role=os.environ["SNOWFLAKE_ROLE"],
        warehouse=os.environ["SNOWFLAKE_WAREHOUSE"],
        database=os.environ["SNOWFLAKE_DATABASE"],
        schema=os.environ["SNOWFLAKE_SCHEMA"],
    )
    df = pd.read_sql(query, conn)
    conn.close()
    return df
```

Detta skyddar känsliga uppgifter och gör att koden enkelt kan flyttas mellan olika miljöer, till exempel från en lokal dator till en molnbaserad server.

### Interaktiv visualisering med Streamlit

Streamlit är ett Python-baserat ramverk för att snabbt bygga datadrivna webbapplikationer och dashboards med tabeller, diagram och filter. Applikationen hämtar bearbetade jobbannonser från mart-lagret och presenterar dem med nyckeltal (KPI:er), diagram och filtreringsmöjligheter:

```python
# app.py
import streamlit as st
from connect_data_warehouse import get_dataframe

st.title("Jobbannonser – dashboard")

df = get_dataframe("SELECT * FROM mart_technical_jobs")

col1, col2 = st.columns(2)
col1.metric("Antal annonser", len(df))
col2.metric("Snitt lediga tjänster", round(df["number_of_vacancies"].mean(), 1))

occupation_filter = st.multiselect(
    "Yrkesområde", options=df["occupation_field"].unique()
)
if occupation_filter:
    df = df[df["occupation_field"].isin(occupation_filter)]

st.bar_chart(df.groupby("municipality").size())
st.dataframe(df)
```

Detta gör det möjligt för slutanvändare att utforska data visuellt direkt mot datalagrets mart-lager, utan att behöva skriva egna SQL-frågor.

### Tekniska termer

- **Streamlit** — ett Python-bibliotek för att bygga och dela interaktiva webbaserade dashboards.
- **snowflake-connector-python** — Pythons officiella anslutningsdrivrutin för att köra frågor mot Snowflake.
- **.env (miljövariabler)** — en konfigurationsfil för att lagra hemligheter och anslutningsparametrar lokalt.
- **Mart Layer (marts-lager)** — det färdigbearbetade skiktet i datalagret där rapportverktyget hämtar sin data.

### Kontrollfrågor

1. Varför är det viktigt att använda en dedikerad läsarroll (`job_ads_reporter_role`) med enbart `SELECT`-rättigheter när du kopplar en dashboard till ditt datalager istället för att använda ditt personliga konto eller ett skrivkonto?
2. Hur används filen `.env` tillsammans med Python-koden för att hålla anslutningsuppgifter till Snowflake säkra?
3. Vilken roll spelar mart-lagret (Data Marts) när du bygger upp en Streamlit-dashboard jämfört med att hämta data direkt från staging-lagret?

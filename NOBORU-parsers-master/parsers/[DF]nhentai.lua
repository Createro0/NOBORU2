nhentai = Parser:new("nhentai", "https://nhentai.to", "DIF", "NHENTAI", 5)

nhentai.NSFW = true

local CDN = "https://zrocdn.xyz"

local function stringify(str)
	return str:gsub(
		"&#([^;]-);",
		function(a)
			local number = tonumber("0" .. a) or tonumber(a)
			return number and u8c(number) or "&#" .. a .. ";"
		end
	):gsub(
		"&(.-);",
		function(a)
			return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&" .. a .. ";"
		end
	)
end

local function downloadContent(link)
	local f = {}
	Threads.insertTask(
		f,
		{
			Type = "StringRequest",
			Link = link,
			Table = f,
			Index = "text"
		}
	)
	while Threads.check(f) do
		coroutine.yield(false)
	end
	return f.text or ""
end

local function fixUrl(url)
	if url:match("^https?://") then
		return url
	end
	if url:sub(1, 1) == "/" then
		return "https://nhentai.to" .. url
	end
	return CDN .. url
end

function nhentai:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for href, img, name in content:gmatch('href="(/g/%d+/)".-data%-src="([^"]+)".-class="caption">([^<]-)</div>') do
		dt[#dt + 1] = CreateManga(stringify(name), href, fixUrl(img), self.ID, self.Link .. href)
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function nhentai:getPopularManga(page, dt)
	self:getManga(self.Link .. "/home?page=" .. page, dt)
end

function nhentai:searchManga(search, page, dt)
	self:getManga(self.Link .. "/search/?q=" .. search .. "&page=" .. page, dt)
end

function nhentai:getChapters(manga, dt)
	dt[#dt + 1] = {
		Name = "Read",
		Link = manga.Link,
		Pages = {},
		Manga = manga
	}
end

function nhentai:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. chapter.Link)
	local media_id = content:match('"media_id"%s*:%s*"(%d+)"') or content:match('"media_id"%s*:%s*(%d+)')
	if media_id then
		local n = 0
		for _ in content:gmatch('class="gallerythumb"') do
			n = n + 1
		end
		if n > 0 then
			for i = 1, n do
				dt[#dt + 1] = CDN .. "/galleries/" .. media_id .. "/" .. i .. ".webp"
			end
			return
		end
	end
	for link in content:gmatch('class="gallerythumb".-href="(%S-)"') do
		dt[#dt + 1] = self.Link .. link
	end
end

function nhentai:loadChapterPage(link, dt)
	if link:match("^https://") and link:match("%.webp$") then
		dt.Link = link
		return
	end
	local content = downloadContent(link)
	dt.Link = content:match('src="(https://zrocdn%.xyz/galleries/%d+/%d+%.webp)"')
		or content:match('src="(https://[^"]+%.webp)"')
		or content:match('image%-container".-src="(%S-)"')
end

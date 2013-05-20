SitemapGenerator::Sitemap.default_host = "http://www.getboardgames.com"
SitemapGenerator::Sitemap.sitemaps_host = "https://s3.amazonaws.com/getboardgames/sitemap/"
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new

SitemapGenerator::Sitemap.create do
  add '/', :changefreq => 'daily'
  add '/boardgames', :changefreq => 'weekly'
  add '/blog/1', :changefreq => 'weekly'
end

SitemapGenerator::Sitemap.ping_search_engines
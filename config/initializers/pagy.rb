require 'pagy/extras/metadata'
require 'pagy/extras/items'

Pagy::DEFAULT[:items_param] = :per_page
Pagy::DEFAULT[:metadata] = [:pages, :page, :count, :items]

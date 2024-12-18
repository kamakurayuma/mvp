module ApplicationHelper
    def show_meta_tags(board = nil)
      # boardがnilでない場合にメタタグを設定
      assign_meta_tags(board) if display_meta_tags.blank?
      display_meta_tags
    end
  
    def assign_meta_tags(board = nil)
        # デフォルトのメタタグ設定を取得
        defaults = default_meta_tags
        options = {}
      
        # boardが存在し、画像がある場合の処理
        if board.present? && board.respond_to?(:board_image) && board.board_image.present?
          options[:image] = board.board_image.url
        end
      
        # Twitterカード用のメタタグを設定
        options[:twitter] = {
          card: 'summary_large_image', # カードの種類
          title: board.present? ? board.title : 'オールドコンデジ専用投稿サービス',
          description: board.present? ? board.description : 'OldCam1700は、1700万画素以下のオールドコンデジが生み出す写真や動画の味わい深い魅力を楽しみ、共有するための投稿プラットフォームです。',
          image: options[:image],       # 投稿画像
          hashtags: 'OldCam1700'       # 自動で表示させたいハッシュタグ
        }
      
        # optionsのデフォルトをreverse_mergeで設定
        options.reverse_merge!(defaults)
      
        set_meta_tags(options)  # メタタグを設定
    end
  
    def default_meta_tags(board = nil)
        image = if board.present? && board.image.attached?
                  url_for(board.image) # 投稿画像を使用
                else
                  image_url('default-og-image.png') # デフォルト画像を使用
                end
      
        {
          site: 'OldCam1700',
          title: board.present? ? board.title : 'オールドコンデジ専用投稿サービス', 
          reverse: true,
          charset: 'utf-8',
          description: board.present? ? board.description : 'OldCam1700は、1700万画素以下のオールドコンデジが生み出す写真や動画の味わい深い魅力を楽しみ、共有するための投稿プラットフォームです。',
          canonical: request.original_url,
          separator: '|',
          og: {
            site_name: 'OldCam1700',
            title: board.present? ? board.title : 'オールドコンデジ専用投稿サービス',
            description: board.present? ? board.description : 'OldCam1700は、1700万画素以下のオールドコンデジが生み出す写真や動画の味わい深い魅力を楽しみ、共有するための投稿プラットフォームです。',
            type: 'website',
            url: request.original_url,
            image: image, # 投稿画像またはデフォルト画像
            locale: 'ja-JP'
          },
          twitter: {
            card: 'summary_large_image',
            title: board.present? ? board.title : 'オールドコンデジ専用投稿サービス',
            description: board.present? ? board.description : 'OldCam1700の魅力をシェアしよう！',
            image: image, 
            hashtags: 'OldCam1700'
        }

        }
      end
end
  
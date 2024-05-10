module PopEngine
  class Collection
    include Enumerable

    attr_reader :data, :count, :next_cursor, :has_more, :too_big, :from_command

    class << self
      def from_response(body, key:, type:)
        new(data: body[key].map{ |attrs| type.new(attrs) },
            count: body['count'] || body[key].size,
            next_cursor: next_cursor(body),
            has_more: body['has_more'],
            too_big: body['too_big'],
            from_command: body['command_from'])
      end

      def null
        new(data: [], count: 0)
      end

      private

      def next_cursor(body)
        return nil unless body['has_more'] == true

        { assessment_id: body['next_app_id'], account_id: body['next_acc_id'], date: body['next_date'] }
      end
    end

    def initialize(data:, count:, next_cursor: nil, has_more: false, too_big: false, from_command: nil)
      @data = data
      @count = count
      @next_cursor = next_cursor
      @has_more = has_more
      @too_big = too_big
      @from_command = from_command
    end

    def each(&block)
      data.each(&block)
      self
    end
  end
end

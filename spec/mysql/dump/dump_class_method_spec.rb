# frozen_string_literal: true

describe 'Ridgepole::Client.dump' do
  context 'when there is a tables' do
    before { restore_tables }
    subject { Ridgepole::Client }

    it {
      expect(subject.dump(conn_spec, dump_without_table_options: true)).to match_fuzzy erbh(<<-ERB)
        create_table "clubs", <%= i cond({ '>= 5.1, < 6.1' => { id: :integer, unsigned: true }, ">= 6.1" => { id: { type: :integer, unsigned: true } } }, { unsigned: true }) %>, force: :cascade do |t|
          t.string "name", default: "", null: false
          t.index ["name"], name: "idx_name", unique: true
        end

        create_table "departments", primary_key: "dept_no", <%= i cond(">= 6.1", { id: { type: :string, limit: 4 } }, { id: :string, limit: 4 }) %>, force: :cascade do |t|
          t.string "dept_name", limit: 40, null: false
          t.index ["dept_name"], name: "dept_name", unique: true
        end

        create_table "dept_emp", primary_key: ["emp_no", "dept_no"], force: :cascade do |t|
          t.integer "emp_no", null: false
          t.string  "dept_no", limit: 4, null: false
          t.date    "from_date", null: false
          t.date    "to_date", null: false
          t.index ["dept_no"], name: "dept_no"
          t.index ["emp_no"], name: "emp_no"
        end

        create_table "dept_manager", primary_key: ["emp_no", "dept_no"], force: :cascade do |t|
          t.string  "dept_no", limit: 4, null: false
          t.integer "emp_no", null: false
          t.date    "from_date", null: false
          t.date    "to_date", null: false
          t.index ["dept_no"], name: "dept_no"
          t.index ["emp_no"], name: "emp_no"
        end

        create_table "employee_clubs", <%= i cond({ '>= 5.1, < 6.1' => { id: :integer, unsigned: true }, ">= 6.1" => { id: { type: :integer, unsigned: true }} }, { unsigned: true }) %>, force: :cascade do |t|
          t.integer "emp_no", null: false, unsigned: true
          t.integer "club_id", null: false, unsigned: true
          t.index ["emp_no", "club_id"], name: "idx_emp_no_club_id"
        end

        create_table "employees", primary_key: "emp_no", id: :integer, <%= i cond('>= 5.1', default: nil) %>, force: :cascade do |t|
          t.date   "birth_date", null: false
          t.string "first_name", limit: 14, null: false
          t.string "last_name", limit: 16, null: false
          <%- if condition('< 6.0.0.beta2') -%>
          t.string "gender", limit: 1, null: false
          <%- else -%>
          t.column "gender", "enum('M','F')", null: false
          <%- end -%>
          t.date   "hire_date", null: false
        end

        create_table "salaries", primary_key: ["emp_no", "from_date"], force: :cascade do |t|
          t.integer "emp_no", null: false
          t.integer "salary", null: false
          t.date    "from_date", null: false
          t.date    "to_date", null: false
          t.index ["emp_no"], name: "emp_no"
        end

        create_table "titles", primary_key: ["emp_no", "title", "from_date"], force: :cascade do |t|
          t.integer "emp_no", null: false
          t.string  "title", limit: 50, null: false
          t.date    "from_date", null: false
          t.date    "to_date"
          t.index ["emp_no"], name: "emp_no"
        end
      ERB
    }
  end
end

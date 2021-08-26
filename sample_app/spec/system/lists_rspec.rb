# frozen_string_literal: true

require 'rails_helper'

describe "投稿のテスト" do
  let!(:list) { create(:list, title: 'hoge', body: 'body') }

  describe "トップ画面(top_path)のテスト" do
    before do
      visit top_path
    end

    context "表示の確認" do
      it "トップ画面(top_path)に「ここはTopページです」が表示されているか" do
        expect(page).to have_content("ここはTopページです")
      end
      it "top_pathが'/top'であるか" do
        expect(current_path).to eq("/top")
      end
    end
  end

  describe "投稿画面のテスト" do
    before do
      visit todolists_new_path
    end

    context "表示の確認" do
      it 'todolists_new_pathが"/todolists/new"であるか' do
        expect(current_path).to eq("/todolists/new")
      end
      it "投稿ボタンが表示されているか" do
        expect(page).to have_button "投稿"
      end
    end

    context "投稿処理のテスト" do
      it "投稿後のリダイレクト先は正しいか" do
        fill_in "list[title]", with: Faker::Lorem.characters(number: 5)
        fill_in "list[body]", with: Faker::Lorem.characters(number: 20)
        click_button "投稿"
        expect(page).to have_current_path todolist_path(List.last)
      end
    end
  end

  describe "一覧画面のテスト" do
    before do
      visit todolists_path
    end

    context "一覧の表示とリンクの確認" do
      it "一覧表示画面に投稿されたもの表示されているか" do
        (1..5).each do |i|
          List.create(title: "hoge" + i.to_s, body: "body" + i.to_s)
        end
        visit todolists_path
        List.all.each_with_index do |list, i|
          expect(page).to have_content list.title
          expect(page).to have_content list.body
          expect(page).to have_link "", href: todolist_path(list.id)
        end
      end
    end
  end

  describe "詳細画面のテスト" do
    before do
      visit todolist_path(list)
    end

    context "表示のテスト" do
      it "削除リンクが存在しているか" do
        destroy_link = find_all('a')[4]
        expect(destroy_link.native.inner_text).to match("削除")
        expect(destroy_link[:href]).to eq todolist_path(list)
      end
      it "編集リンクが存在しているか" do
        edit_link = find_all('a')[3]
        expect(edit_link.native.inner_text).to match("編集")
        expect(edit_link[:href]).to eq edit_todolist_path(list)
      end
    end

    context "リンクの遷移先の確認" do
      it "編集の遷移先は編集画面か" do
        edit_link = find_all('a')[3]
        edit_link.click
        expect(current_path).to eq("/todolists/" + list.id.to_s + "/edit")
      end
    end

    context "list削除のテスト" do
      it "listの削除" do
        expect { list.destroy }.to change(List, :count).by(-1)
      end
    end
  end

  describe "編集画面のテスト" do
    before do
      visit edit_todolist_path(list)
    end

    context "表示の確認" do
      it "編集前のタイトルと本文がフォームに表示(セット)されている" do
        expect(page).to have_field "list[title]", with: list.title
        expect(page).to have_field "list[body]", with: list.body
      end
      it "保存ボタンが表示される" do
        expect(page).to have_button '保存'
        fill_in "list[title]", with: "testtitle"
        fill_in "list[body]", with: "testbody"
        click_button "保存"
        expect(page).to have_content "testtitle"
        expect(page).to have_content "testbody"
      end
    end

    context "更新処理に関するテスト" do
      it "更新後のリダイレクト先は正しいか" do
        fill_in "list[title]", with: "testtitle"
        fill_in "list[body]", with: "testbody"
        click_button "保存"
        expect(page).to have_current_path todolist_path(list)
      end
    end
  end
end
